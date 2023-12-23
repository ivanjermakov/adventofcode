import { readFileSync } from 'fs'
import { max } from 'lodash'
import { Pos } from '../day10/day10a'
import { fromKey, key } from '../day21/day21a'

export function readInput(): string {
    return readFileSync('data/day23.txt').toString().trim()
}

export function solve(input: string): number {
    const cells = new Map<string, string>(
        input.split('\n')
            .flatMap((r, i) => r.split('').flatMap((c, j) => c === '#' ? [] : [[key([i, j]), c]]))
    )
    const start = <Pos>fromKey([...cells.keys()][0])
    const end = [...cells.keys()].at(-1)!
    const ps = traverse(start, end, cells, [])
    return max(ps.map(p => p.length - 1))!
}

export function traverse(cell: Pos, end: string, cells: Map<string, string>, path: string[]): string[][] {
    const pss: string[][] = []
    const k = key(cell)
    const v = cells.get(k)
    if (v) {
        if (k === end) return [[...path, k]]
        let next: Pos[]
        if (v === '^') { next = [[-1, 0]] }
        else if (v === '>') { next = [[0, 1]] }
        else if (v === 'v') { next = [[1, 0]] }
        else if (v === '<') { next = [[0, -1]] }
        else { next = [[-1, 0], [0, 1], [1, 0], [0, -1]] }
        for (const n of next) {
            const nPos = <Pos>[cell[0] + n[0], cell[1] + n[1]]
            const nKey = key(nPos)
            if (nKey === end) return [[...path, k, nKey]]
            if (path.includes(nKey)) continue
            if (cells.has(nKey)) {
                const ps = traverse(nPos, end, cells, [...path, k]).filter(p => p.length > 0)
                pss.push(...ps)
            }
        }
    }
    return pss
}
