import { readFileSync } from 'fs'
import { Pos } from '../day10/day10a'
import { range } from 'lodash'

export function readInput(): string {
    return readFileSync('data/day11.txt').toString().trim()
}

export function solve(input: string): number {
    const ps = expand(input)
    return [...comb2(ps)].map(([a, b]) => manhattanDist(a, b)).reduce((a, b) => a + b, 0)
}

export function expand(input: string): Pos[] {
    const grid = input.split('\n').map(l => l.split(''))
    const expFn = <T>(l: T[]) => l.every(c => c !== '#') ? [l, l] : [l]
    const expGrid = transpose(transpose(grid.flatMap(expFn)).flatMap(expFn))
    return expGrid.flatMap((l, i) => l
        .map((c, j) => <const>[c, j])
        .filter(([c,]) => c === '#')
        .map(([, j]) => <Pos>[i, j])
    )
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
