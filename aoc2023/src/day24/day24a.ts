import { readFileSync } from 'fs'
import { inRange } from 'lodash'
import { Pos } from '../day10/day10a'
import { Pos3 } from '../day22/day22a'
import { Range } from '../day5/day5a'

export interface Ray {
    pos: Pos3
    dir: Pos3
}

export function readInput(): string {
    return readFileSync('data/day24.txt').toString().trim()
}

export function solve(input: string, range: Range): number {
    const rs: Ray[] = input.split('\n').map(row => {
        const [l, r] = row.split(' @ ')
        const poss = l.split(', ').map(n => parseInt(n))
        const dirs = r.split(', ').map(n => parseInt(n))
        return { pos: { x: poss[0], y: poss[1], z: poss[2] }, dir: { x: dirs[0], y: dirs[1], z: dirs[2] } }
    })
    let res = 0
    for (let i = 0; i < rs.length - 1; i++) {
        for (let j = i + 1; j < rs.length; j++) {
            const a = rs[i]
            const b = rs[j]
            const p = intersect(a, b)
            if (!p) continue
            if (inRange(p[0], range[0], range[1]) && inRange(p[1], range[0], range[1])) {
                res++
            }
        }
    }
    return res
}

/**
 * @link https://stackoverflow.com/questions/2931573/determining-if-two-rays-intersect
 */
export function intersect(a: Ray, b: Ray): Pos | undefined {
    const dx = b.pos.x - a.pos.x
    const dy = b.pos.y - a.pos.y
    const det = b.dir.x * a.dir.y - b.dir.y * a.dir.x
    const u = (dy * b.dir.x - dx * b.dir.y) / det
    const v = (dy * a.dir.x - dx * a.dir.y) / det
    if (u < 0 || v < 0) return undefined

    const m0 = a.dir.y / a.dir.x
    const m1 = b.dir.y / b.dir.x
    const b0 = a.pos.y - m0 * a.pos.x
    const b1 = b.pos.y - m1 * b.pos.x
    const x = (b1 - b0) / (m0 - m1)
    const y = m0 * x + b0

    return Number.isFinite(x) ? [x, y] : undefined
}
