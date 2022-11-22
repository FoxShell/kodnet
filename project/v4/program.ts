import Path from 'path'
import Os from 'os'
import fs from 'fs'
import Child from 'child_process'
import {paths} from '../paths.ts'
import {Registry, registry} from "github://kwruntime/win32reg@8408ff6/src/mod.ts"
import * as async from "gh+/kwruntime/std@1.1.14/util/async.ts"


async function parseRegedit(content: string){
	let lines = content.split(/\r?\n/g)

	let state = {
		current: '',
		token: ''
	}
	let obj:any = {}
	for(let i=0;i<lines.length;i++){
		let line = lines[i]
		if(state.token == 'waiting'){

			if(!line){
				state.token = ''
				continue 
			}

			let y = line.indexOf("=")
			let pname= line.substring(0, y)
			if(pname[0] == '"'){
				pname = JSON.parse(pname)
			}
			let pvalue = line.substring(y+1)
			if(pvalue[0] == '"'){
				pvalue = JSON.parse(pvalue)
			}

			if(pname == "@"){
				obj[state.current][pname] = {
					"type": "REG_DEFAULT",
					value: pvalue
				}
			}
			else{
				obj[state.current][pname] = {
					"type": "REG_SZ",
					value: pvalue
				}
			}
		}
		else if(line.startsWith("[")){
			let name = line.substring(1, line.length - 1)
			name = name.replace("HKEY_CURRENT_USER\\","HKCU\\")
			name = name.replace("HKEY_CLASSES_ROOT\\","HKCR\\")

			state.current = name 
			state.token = 'waiting'
			obj[name] = {}
		}
	}
	return obj
}


export class Program{
    static async main(){

        try{

            let getFolder = async function(admin = false){

                let home = Os.homedir()
                if(admin){
                    home = process.env.PROGRAMDATA
                }

                let KwRuntimeFolder = Path.join(home, "KwRuntime")
                if (!fs.existsSync(KwRuntimeFolder)) {
                    try {
                        await fs.mkdirSync(KwRuntimeFolder)
                    } catch (e) { }
                }

            
                let kodnet = Path.join(KwRuntimeFolder, "kodnet")
                if(fs.existsSync(kodnet)){
                    try{
                        await fs.promises.rm(kodnet, {
                            recursive: true
                        })
                    }catch(e){}
                }
                return kodnet 
            }

            let copyFiles = async function(kodnet: string){
                let commonfolder = paths.common
                let filesc = await fs.promises.readdir(commonfolder)
                await fs.promises.cp(paths.v4, kodnet,{
                    recursive: true
                })
                for(let file of filesc){
                    let ufile = Path.join(commonfolder, file)
                    await fs.promises.cp(ufile, Path.join(kodnet,file), {
                        recursive: true
                    })	
                }
            }
            
            let kodnet = await getFolder()
            await copyFiles(kodnet)




            let platform = Os.platform()
            let asadmin = false
            if (platform == "win32") {
                let def = new async.Deferred<number>()
                let p = Child.spawn('fltmc', [])
                p.on("error", def.reject)
                p.on("exit", def.resolve)
                let num = 0
                try{
                    num = await def.promise 				
                }catch(e){
                    def = new async.Deferred<number>()
                    p = Child.spawn('net', ['session'])
                    p.on("error", def.reject)
                    p.on("exit", def.resolve)
                    num = await def.promise 
                }
                asadmin = num < 1
            }else{
                console.error("[WARNING] No windows platform")
                //return 
            }


            let dll = Path.join(paths.v4, "lib", "Kodnet.dll")
            let uri = "file:///" + dll.replace(/\\/g, '/')
            let regs = []
            if(!asadmin){
                // no admin 
                console.info("> Registering Interop for \x1b[33m.NET Framework 4.5+\x1b[0m (user mode, non admin)")
                let regfile1 = Path.join(paths.v4, "reg", "user.reg")
                let regfile2 = Path.join(paths.v4, "reg", "user6432.reg")
                let content = await fs.promises.readFile(regfile1,'utf8')
                while(content.indexOf("${file_uri}") >= 0){
                    content = content.replace("${file_uri}", uri)
                }
                regs.push(await parseRegedit(content))

                content = await fs.promises.readFile(regfile2,'utf8')
                while(content.indexOf("${file_uri}") >= 0){
                    content = content.replace("${file_uri}", uri)
                }
                regs.push(await parseRegedit(content))
            }
            else{

                let kodnet = await getFolder(true)
                await copyFiles(kodnet)

                console.info("> Registering Interop for \x1b[33m.NET Framework 4.5+\x1b[0m (admin mode)")
                let regfile1 = Path.join(paths.v4, "reg", "admin.reg")			
                let regfile2 = Path.join(paths.v4, "reg", "admin6432.reg")
                let content = await fs.promises.readFile(regfile1,'utf8')
                while(content.indexOf("${file_uri}") >= 0){
                    content = content.replace("${file_uri}", uri)
                }
                regs.push(await parseRegedit(content))	
                
                content = await fs.promises.readFile(regfile2,'utf8')
                while(content.indexOf("${file_uri}") >= 0){
                    content = content.replace("${file_uri}", uri)
                }
                regs.push(await parseRegedit(content))
            }


            /*
            let winregPath = Path.join(Os.homedir(), "KwRuntime", "runtime", "node_modules", "winreg-vbs")
            let WinReg = require(winregPath)
            */

            

            for(let reg of regs){
                //console.info("Reg:",reg)
                let items = Object.keys(reg)

                /*
                let def = new async.Deferred<void>()
                WinReg.createKey(items, (e) => e ? def.reject(e) : def.resolve())
                await def.promise

                def = new async.Deferred<void>()
                WinReg.putValue(reg, (e) => e ? def.reject(e) : def.resolve())
                await def.promise
                */

                await registry.createKeys(items)
                await registry.putValues(reg)

            }


        
        }catch(e){
            console.error("> Failed installing kodnet: ",e )
        }

    }
}