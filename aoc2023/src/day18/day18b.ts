import { isEqual } from "lodash"
import { Pos } from "../day10/day10a"
import { assert } from "../util"
import { DigInstruction, Dir, dirToMove } from "./day18a"

export function solve(input: string): number {
    const instructions: DigInstruction[] = input.split('\n').map(l => {
        const hex = l.split('#')[1].replaceAll(')', '')
        return { dir: <Dir>"RDLU"[parseInt(hex[5], 16)], count: parseInt(hex.substring(0, 5), 16) }
    })
    const nodes = []
    let pos = <Pos>[0, 0]
    for (const inst of instructions) {
        const m = dirToMove(inst.dir)
        pos = [pos[0] + inst.count * m[0], pos[1] + inst.count * m[1]]
        nodes.push(pos)
    }
    assert(isEqual(nodes.at(-1)!, [0, 0]))

    let sum = 0
    for (let i = 0; i < nodes.length - 1; i++) {
        const a = nodes[i]
        const b = nodes[i + 1]
        sum += (a[1] * b[0])
        sum -= (a[0] * b[1])
    }

    const permieter = instructions.map(n => n.count).reduce((a, b) => a + b, 0)
    return (permieter / 2 + 1) + 0.5 * sum
}

