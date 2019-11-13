
//import 'https://kwx.kodhe.com/x/v/0.6.7/std/dist/stdlib'
import 'npm://fs-extra@8.1.0'
//import fs from '/virtual/@kawix/std/fs/mod'
import Path from 'path'
import Os from 'os'
import fs from 'fs-extra'
import Child from 'child_process'


main()
async function main(){

    console.info("Installing kodnet ...")

    try{
        let KawixDir = Path.join(Os.homedir(), "Kawix")
		let ShideLibDir = Path.join(KawixDir, "Shide.lib")
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
    }catch(e){
        console.error("Failed installing shide: ",e )
    }

}