import readline from 'readline'
import {KModule, kawix} from "github://kwruntime/core@8a14c7d/src/kwruntime.ts"
import Module from 'module'
import Url from 'url'
import {Exception} from "github://kwruntime/std@1.1.19/util/exception.ts"
import * as async from "github://kwruntime/std@1.1.19/util/async.ts"
import fs from 'fs'
import Path from 'path'
import Os from 'os'
import crypto from 'crypto'


let userData = Path.join(Os.homedir(),".kawi","user-data")
if(!fs.existsSync(userData)){
	fs.mkdirSync(userData)
}

userData=Path.join(userData, "com.kodhe.shide")
if(!fs.existsSync(userData)){
	fs.mkdirSync(userData)
}

userData=Path.join(userData, String(process.pid))
if(!fs.existsSync(userData)){
	fs.mkdirSync(userData)
}


export class Program{

	#modules = new Map<string, any>()

	static async main(){
		try{

			if(kawix.appArguments[1]){
				this.#startCheckProcess(Number(kawix.appArguments[1]))
			}
			await new Program().main()
		}catch(e){
			console.info("##", JSON.stringify({
				type: 'event',
				name:'error',
				value:{
					message: e.message,
					code: e.code || 'UNKNOWN'
				}
			}))
			process.exit(0)
		}
	}


	static async #startCheckProcess(pid: number){
		console.info("Checking pid:", pid)
		function pidIsRunning(pid) {
			try {
			  process.kill(pid, 0);
			  return true;
			} catch(e) {
			  return false;
			}
		}

		while(true){
			if(!pidIsRunning(pid))
				break 

			await async.sleep(5000)
		}

		process.exit(0)
	}


	async main(){
		this.#write({
			type: 'event',
			name:'started'
		})
		process.stdin.resume()
		process.stdin.setEncoding('utf8')
		let reader = readline.createInterface({
			input: process.stdin,
			terminal: false
		})

		process.stdin.on("data", function(){

			console.info("Line received...")
		})
		reader.on("line", (line) => {
			this.#execute(line)
		})


		setInterval(function(){}, 100000)
	}


	#write(cmd: any){
		console.info("##", JSON.stringify(cmd))
	}

	async #execute(line: string){
		try{
			if(line?.startsWith("##")){
				let json = line.substring(2)
				let cmd = JSON.parse(json)
				let cmdr:any = {
					type: 'task',
					uid: cmd.uid,
					name: cmd.name,
					status: 'ok'
				}

				
				console.info("Received cmd:", cmd)
				if(cmd.type == "task"){

					console.info("Task received::", cmd)

					try{
						let mod = this.#modules.get(cmd.name)
						let result = null
						if(!mod){
							throw Exception.create("Module with name: " + cmd.name + " not found").putCode("MODULE_NOT_FOUND")
						}

						let func = mod[cmd.method]
						if(!func){
							throw Exception.create("Function with name: " + cmd.name  + "." + cmd.method + " not found").putCode("MODULE_NOT_FOUND")
						}


						if(typeof func == "function"){
							result = await func.apply(mod, cmd.params || [cmd.param])
						}
						else{
							result = func 
						}

						cmdr.value = result 

					}catch(e){
						
						cmdr.status = 'error'
						cmdr.error = {
							message: e.message,
							stack: e.stack,
							code: e.code
						}

					}

					this.#write(cmdr)

				}


				if(cmd.type == "module"){

					try{

						let ext = Path.extname(cmd.name), file = '', add = ''
						if(!ext){
							add = '.ts'
						}
						file = Path.join(userData, cmd.name + add)

						/*
						let mod = new Module(cmd.name)
						mod.filename = `/shide/${cmd.name}.ts`
						mod.exports = {
							__local__vars : {},
							__filename: mod.filename,
							__source: {
								stat: {
									mtimeMs: 0,
									ctimeMs: 0
								},
								content: cmd.code 
							}
						} 

						let url = Url.pathToFileURL(mod.filename)
						await kawix.defaultCompileAndExecute(mod, {
							url,
							uri: new URL(url) 
						})
						let keys = Object.keys(mod.exports)
						this.#modules.set(cmd.name, mod)
						*/

						let additionalCode = `

						export function $evaluate(){
							let $_params = arguments[0]
							let params = $_params.params
							let globals = global.shide_globals = global.shide_globals || {}
							let locals = module.exports.locals = module.exports.locals || {}
							return eval($_params.code)
						}

						export function $evaluateAsync(){
							let $_params = arguments[0]
							let params = $_params.params
							let globals = global.shide_globals = global.shide_globals || {}
							let locals = module.exports.locals = module.exports.locals || {}
							let func = eval("async function(){\\n" + $_params.code + "\\n}")
							return func()
						}
						
						`

						await fs.promises.writeFile(file, cmd.code + additionalCode)
						let mod = await import(file)
						let keys = Object.keys(mod)
						this.#modules.set(cmd.name, mod)

						
						
						cmdr.value = {
							methods: keys
						}

					}catch(e){
						
						cmdr.status = 'error'
						cmdr.error = {
							message: e.message,
							stack: e.stack,
							code: e.code
						}

					}

					this.#write(cmdr)

				}
			}
		}catch(e){
			console.info("> Failed process cmd:", e)
		}
	}
}