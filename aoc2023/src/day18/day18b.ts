import { DigInstruction, Dir } from "./day18a"

export function parse(input: string): DigInstruction[] {
    return input.split('\n').map(l => {
        const hex = l.split('#')[1].replaceAll(')', '')
        return { dir: <Dir>"RDLU"[parseInt(hex[5], 16)], count: parseInt(hex.substring(0, 5), 16) }
    })
}

