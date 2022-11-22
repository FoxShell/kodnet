import fs from 'fs'
import fse from 'npm://fs-extra@10.1.0'

import {Program as V1} from './legacy/program.ts'
import {Program as V4} from './v4/program.ts'
import {Program as net6} from './net6/program.ts'
import {Registry, registry} from "github://kwruntime/win32reg@8408ff6/src/mod.ts"

export class Program{
    static async main(){

        let code = 0
        try{
            
            //fs.promises.cp = cpFn
            if(!fs.promises.cp){
                fs.promises.cp = fse.copy.bind(fse)
            }

            fs.promises.cp = fse.copy.bind(fse)

            
            await V1.main()
            await V4.main()
            await net6.main()

            console.info("> Proceso completado")

        }catch(e){
            code = 1
            console.error("> Error:", e)
            
        }
        finally{
            process.stdout.write("Press ENTER to exit ")
            process.stdin.resume()
            process.stdin.on("data", ()=> process.exit(code))
        }

    }
}