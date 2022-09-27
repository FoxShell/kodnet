import {Packager} from '../../Kodhe/kwruntime/std/package/compiler/pack.ts'
import {Builder} from '../../Kodhe/kwruntime/std/package/compiler/build.ts'
import Path from 'path'
import fs from 'fs'
main()
async function main(){

	let workingFolder = Path.join(__dirname, "dist")
	if(!fs.existsSync(workingFolder)) fs.mkdirSync(workingFolder)
	

	let packer = new Packager({
		workingFolder,
		root: Path.join(__dirname, "project"),
		follow: true,
		hash: "com.kodhe.kodnet-2.0.7-6",
		useDataFolder: true,
		main: "main.ts"
	})

	await packer.add([
		Path.join(__dirname, "project")
	])
	await packer.writeTo(Path.join(workingFolder, "kodnet-2.0.7.kwc"))

}