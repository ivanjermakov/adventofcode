import { readFileSync } from 'fs'
import { isEqual } from 'lodash'
import { Pos } from '../day10/day10a'
import { assert } from '../util'

export type Dir = 'U' | 'R' | 'D' | 'L'

export function dirToMove(dir: Dir): Pos {
    switch (dir) {
        case 'U': return [-1, 0]
        case 'R': return [0, 1]
        case 'D': return [1, 0]
        case 'L': return [0, -1]
    }
}

export interface DigInstruction {
    dir: Dir
    count: number
}

export function readInput(): string {
    return readFileSync('data/day18.txt').toString().trim()
}

export function parse(input: string): DigInstruction[] {
    return input.split('\n').map(l => {
        const [dir, count] = l.replaceAll(/\(|\)/g, '').split(' ')
        return { dir: <Dir>dir, count: parseInt(count) }
    })
}

export function solve(instructions: DigInstruction[]): number {
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

