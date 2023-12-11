import { readFileSync } from 'fs'
import { Pos } from '../day10/day10a'
import { range } from 'lodash'

export function readInput(): string {
    return readFileSync('data/day11.txt').toString().trim()
}

export function solve(input: string, scale: number = 2): number {
    const grid = input.split('\n').map(l => l.split(''))
    const empty = <const>[getEmptyIds(grid), getEmptyIds(transpose(grid))]
    const ps = grid.flatMap((l, i) => l
        .map((c, j) => <const>[c, j])
        .filter(([c,]) => c === '#')
        .map(([, j]) => <Pos>[i, j])
    )
    return [...comb2(ps)].map(([[ai, aj], [bi, bj]]) => {
        const colsBetween = empty[0].filter(e => Math.min(ai, bi) < e && Math.max(ai, bi) > e).length
        const rowsBetween = empty[1].filter(e => Math.min(aj, bj) < e && Math.max(aj, bj) > e).length
        const countBetween = colsBetween + rowsBetween
        return manhattanDist([ai, aj], [bi, bj]) + countBetween * (scale - 1)
    }).reduce((a, b) => a + b, 0)
}

export function getEmptyIds(g: string[][]): number[] {
    return g.map((l, i) => <const>[l, i]).filter(([l,]) => l.every(c => c !== '#')).map(([, i]) => i)
}

export function transpose<T>(g: T[][]): T[][] {
    return g[0].map((_, i) => g.map(row => row[i]));
}

export function printGrid(g: string[][]) {
    g.forEach(l => console.log(l.join(' ')))
}

export function* comb2<T>(a: T[]): Generator<[T, T], void, undefined> {
    yield* range(a.length).flatMap(i => range(i + 1, a.length).map(j => <[T, T]>[a[i], a[j]]))
}

export function manhattanDist(a: Pos, b: Pos): number {
    return Math.abs(a[0] - b[0]) + Math.abs(a[1] - b[1])
}
