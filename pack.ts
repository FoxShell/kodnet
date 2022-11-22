import {Packager} from '../../Kodhe/kwruntime/std/package/compiler/pack.ts'
import {Builder} from '../../Kodhe/kwruntime/std/package/compiler/build.ts'
import Path from 'path'
import fs from 'fs'
main()
async function main(){

	let workingFolder = Path.join(__dirname, "dist")
	if(!fs.existsSync(workingFolder)) fs.mkdirSync(workingFolder)

	let buildOptions = {
		packager: null,
		npmExternalModules: [
			"@kwruntime/win32reg@0.1.3"
		],
		target: 'node'
	}
	let packer = new Packager({
		workingFolder,
		root: Path.join(__dirname, "project"),
		follow: true,
		hash: "com.kodhe.kodnet-3.0",
		useDataFolder: true,
		main: "program.ts",
		buildOptions
	})
	buildOptions.packager = packer

	/*
	let builder = new Builder(buildOptions)	
	await builder.compile(Path.join(__dirname, "project", "main.ts"))
	await builder.writeTo(Path.join(workingFolder, "kodnet.js"))
	*/
	
	
	await packer.addSourceFile(Path.join(__dirname, "project", "main.ts"), "program.ts")
	await packer.add([
		Path.join(__dirname, "project")
	])
	await packer.writeTo(Path.join(workingFolder, "kodnet-3.0.6.kwc"))

}
