

import Path from 'path'
import Os from 'os'
import fs from 'fs'
import Child from 'child_process'


main()
async function main(){

    console.info("Installing kodnet ...")

    try{
        let KawixDir = Path.join(Os.homedir(), "Kawix")
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




		let p= Child.spawn(Path.join(__dirname,"lib","jxshell.register.exe"),[])
		p.on("error", function(e){
			console.error("Error installing: ", e)
		})
		await new Promise(function(a,b){
			p.on("exit", a)
		})

		p = Child.spawn(Path.join(process.env.SystemRoot, "Microsoft.NET", "Framework", "v4.0.30319", "regasm.exe"),
			["/codebase", Path.join(__dirname, "lib", "jxshell.dotnet4.dll")])
		p.stdout.on("data", process.stdout.write.bind(process.stdout))
		p.on("error", function(e){
			console.error("[Warning] Installing with regasm, ignore if you are not using admin cmd:", e)
		})
		await new Promise(function(a,b){
			p.on("exit", a)
		})

		p = Child.spawn(Path.join(process.env.SystemRoot, "Microsoft.NET", "Framework64", "v4.0.30319", "regasm.exe"),
			["/codebase", Path.join(__dirname, "lib", "jxshell.dotnet4.dll")])
		p.stdout.on("data", process.stdout.write.bind(process.stdout))
		p.on("error", function(e){
			console.error("[Warning] Installing with regasm, ignore if you are not using admin cmd:", e)
		})
		await new Promise(function(a,b){
			p.on("exit", a)
		})

    }catch(e){
        console.error("Failed installing shide: ",e )
    }

}