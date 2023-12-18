import { readFileSync } from 'fs'
import { Pos } from '../day10/day10a'
import { assert } from '../util'
import { isEqual } from 'lodash'
import { posEq } from '../day17/day17a'

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
    color: string
}

export function readInput(): string {
    return readFileSync('data/day18.txt').toString().trim()
}

export function solve(input: string): number {
    const instructions: DigInstruction[] = input.split('\n').map(l => {
        const [dir, count, color] = l.replaceAll(/\(|\)/g, '').split(' ')
        return { dir: <Dir>dir, count: parseInt(count), color }
    })
    const border = []
    let pos = <Pos>[0, 0]
    for (const inst of instructions) {
        const m = dirToMove(inst.dir)
        for (let i = 0; i < inst.count; i++) {
            pos = [pos[0] + m[0], pos[1] + m[1]]
            border.push(pos)
        }
    }
    assert(isEqual(border.at(-1)!, [0, 0]))
    return fill([1, 1], border) + border.length
}

export function fill(start: Pos, border: Pos[]): number {
    const filled = new Set<string>()
    const q = [start]

    while (q.length > 0) {
        const n = q.pop()!
        const key = [n[0], n[1]].join()
        if (filled.has(key)) continue
        if (border.find(b => posEq(b, n))) continue
        filled.add(key)
        for (const d of [[-1, 0], [0, 1], [1, 0], [0, -1]]) {
            q.push([n[0] + d[0], n[1] + d[1]])
        }
    }
    return filled.size
}
