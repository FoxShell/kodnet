import Path from 'path'
import Os from 'os'
import fs from 'fs'
import Child from 'child_process'
import * as async from "gh+/kwruntime/std@1.1.14/util/async.ts"
import {Registry, registry} from "github://kwruntime/win32reg@8408ff6/src/mod.ts"
import {paths} from '../paths.ts'

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

            
                let kodnet = Path.join(KwRuntimeFolder, "kodnet-net6")
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
                await fs.promises.cp(paths.net6, kodnet,{
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


            let dll64 = Path.join(paths.net6, "lib", "x64", "kodnet.comhost.dll").replace(/\\/g, '\\\\')
            let dll32 = Path.join(paths.net6, "lib", "x86", "kodnet.comhost.dll").replace(/\\/g, '\\\\')
            let regs = []
            let usermode = "user mode, non admin"
            let files = ["user.reg", "user6432.reg"]
            if(asadmin){
                usermode = "admin mode"
                files = ["admin.reg", "admin6432.reg"]
            }
            let arch = Os.arch(), bits32 = false
            if(arch == "ia32"){
                console.info("> Looks like you are using a 32 bit machine. If this is not correct, please reinstall KwRuntime for 64 bits")
                bits32 = true
            }
            
            console.info(`> Registering Interop for \x1b[33mNET 6+ x86\x1b[0m (${usermode})`)
            let regfile = Path.join(paths.net6, "reg", "user6432.reg")
            if(bits32){
                regfile = Path.join(paths.net6, "reg", "user.reg")
            }
            let content = await fs.promises.readFile(regfile,'utf8')
            while(content.indexOf("${file}") >= 0){
                content = content.replace("${file}", dll32)
            }
            regs.push(await parseRegedit(content))
            if(!bits32){
                console.info(`> Registering Interop for \x1b[33mNET 6+ x64\x1b[0m (${usermode})`)
                regfile = Path.join(paths.net6, "reg", "user.reg")
                content = await fs.promises.readFile(regfile,'utf8')
                while(content.indexOf("${file}") >= 0){
                    content = content.replace("${file}", dll64)
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