
import {Program as V1} from './v1/program.ts'
import {Program as V2} from './v2/program.ts'
import {Program as net6} from './net6/program.ts'

export class Program{
    static async main(){

        try{

            
            await V1.main()
            await V2.main()
            await net6.main()

        }catch(e){
            console.error("Error:", e)
            process.exit(1)
        }

    }
}