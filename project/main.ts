
import {Program as V1} from './legacy/program.ts'
import {Program as V4} from './v4/program.ts'
import {Program as net6} from './net6/program.ts'

export class Program{
    static async main(){

        try{

            
            await V1.main()
            await V4.main()
            await net6.main()

        }catch(e){
            console.error("Error:", e)
            process.exit(1)
        }

    }
}