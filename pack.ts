import {Packager} from '../../Kodhe/kwruntime/std/package/compiler/pack.ts'
import {Builder} from '../../Kodhe/kwruntime/std/package/compiler/build.ts'
import Path from 'path'
main()
async function main(){

	let workingFolder = Path.join(__dirname, "dist")
	

	let packer = new Packager({
		workingFolder,
		root: Path.join(__dirname, "project"),
		follow: true,
		hash: "com.kodhe.kodnet-2.0",
		useDataFolder: true,
		main: "main.ts"
	})

	await packer.add([
		Path.join(__dirname, "project")
	])
	await packer.writeTo(Path.join(workingFolder, "kodnet-2.0.0.kwc"))

}