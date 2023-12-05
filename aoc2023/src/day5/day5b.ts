import { chunk } from "lodash"
import { Range } from "./day5a"

export function solve(input: string): number {
    let sections = input.split('\n\n')
    let seeds = chunk(sections[0].split(' ').slice(1).map(s => parseInt(s)), 2).map(([st, s]) => <Range>[st, st + s - 1])
    let maps = sections.slice(1).map(section => section.split('\n').slice(1).map(l => l.split(' ').map(s => parseInt(s))))
    const res = maps.reduce((res, m) => [...new Set(res.flatMap(s => map(m, s)))], seeds)
    res.sort((a, b) => a[0] - b[0])
    return res[0][0]
}

export function map(ms: number[][], seed: Range): Range[] {
    const res = ms.flatMap(m => {
        const sourceRange: Range = [m[1], m[1] + m[2] - 1]
        const r = overlap(sourceRange, seed)
        if (!r) return []
        const off = m[0] - sourceRange[0]
        return [[r[0] + off, r[1] + off]]
    })
    return res.length ? res : [seed]
}

/**
 *   a1                     a2
 *   [----------------------)
 *             b1           .         b2
 *             [----------------------)
 *             .            .
 *             [------------)
 *             r1           r2
 */
export function overlap([a1, a2]: Range, [b1, b2]: Range): Range | undefined {
    const r1 = Math.max(a1, b1)
    const r2 = Math.min(a2, b2)
    if (r1 < r2) {
        return [r1, r2]
    }
    return undefined
}
