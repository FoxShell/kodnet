

import Path from 'path'
import Os from 'os'
import fs from 'fs'
import Child from 'child_process'
import * as async from "gh+/kwruntime/std@1.1.14/util/async.ts"

main()

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

async function main(){

    try{
        let KawixDir = Path.join(Os.homedir(), "Kawix")
		if (!fs.existsSync(KawixDir)) {
			try {
				await fs.mkdirSync(KawixDir)
			} catch (e) { }
		}

		let ShideLibDir = Path.join(KawixDir, "Shide.lib")
		if (!fs.existsSync(ShideLibDir)) {
			try {
				await fs.mkdirSync(ShideLibDir)
			} catch (e) { }
		}

		let kodnet = Path.join(ShideLibDir, "kodnet")
        if(fs.existsSync(kodnet)){
			try{
				await fs.unlinkSync(kodnet)
			}catch(e){}
		}
		fs.symlinkSync(Path.join(__dirname), kodnet, "junction")


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


		let dll = Path.join(__dirname, "lib", "jxshell.dotnet4.dll")
		let uri = "file:///" + dll.replace(/\\/g, '/')
		let regs = []
		if(!asadmin){
			// no admin 
			console.info("> Register library in User (non admin) mode")
			let regfile1 = Path.join(__dirname, "reg", "user.reg")
			let regfile2 = Path.join(__dirname, "reg", "user6432.reg")
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
			console.info("> Register library in Admin mode")
			let regfile1 = Path.join(__dirname, "reg", "admin.reg")			
			let content = await fs.promises.readFile(regfile1,'utf8')
			while(content.indexOf("${file_uri}") >= 0){
				content = content.replace("${file_uri}", uri)
			}
			regs.push(await parseRegedit(content))			
		}


		let winregPath = Path.join(Os.homedir(), "KwRuntime", "runtime", "node_modules", "winreg-vbs")
		let WinReg = require(winregPath)
		for(let reg of regs){
			//console.info("Reg:",reg)
			let items = Object.keys(reg)

			let def = new async.Deferred<void>()
			WinReg.createKey(items, (e) => e ? def.reject(e) : def.resolve())
			await def.promise

			def = new async.Deferred<void>()
			WinReg.putValue(reg, (e) => e ? def.reject(e) : def.resolve())
			await def.promise
		}


	
    }catch(e){
        console.error("> Failed installing kodnet: ",e )
    }

}