import { readFileSync } from 'fs'
import { unreachable } from '../util'

const cache = new Map<string, number>()

export function readInput(): string {
    return readFileSync('data/day12.txt').toString().trim()
}

export function solve(input: string): number {
    return input
        .split('\n')
        .map(parse)
        .map(([row, groups]) => solveRow(row, groups))
        .reduce((a, b) => a + b, 0)
}

export function solveRow(row: string[], groups: number[], mustContinue = false): number {
    const key = row.join() + groups.join() + mustContinue
    const cached = cache.get(key)
    if (cached !== undefined) return cached
    const res = solveRow_(row, groups, mustContinue)
    cache.set(key, res)
    return res
}

export function solveRow_(row: string[], groups: number[], mustContinue: boolean): number {
    if (row.length === 0) {
        return groups.length === 0 ? 1 : 0
    }
    if (mustContinue && row[0] === '.') return 0
    if (groups.length === 0) return row.every(e => e !== '#') ? 1 : 0

    if (row[0] === '.') {
        return solveRow(row.slice(1), groups)
    }
    if (row[0] === '#') {
        if (groups[0] === 1) {
            if (row.length > 1 && row[1] === '#') return 0
            if (row.length === 1) {
                return solveRow(row.slice(1), groups.slice(1))
            }
            return solveRow(row.slice(2), groups.slice(1))
        }
        return solveRow(row.slice(1), [groups[0] - 1, ...groups.slice(1)], true)
    }
    if (row[0] === '?') {
        if (mustContinue) {
            return solveRow(['#', ...row.slice(1)], groups, mustContinue)
        }
        return solveRow(['#', ...row.slice(1)], groups, mustContinue) +
            solveRow(['.', ...row.slice(1)], groups, mustContinue)
    }

    return unreachable()
}

export function parse(row: string): [string[], number[]] {
    const [a, b] = row.split(' ')
    return [a.split(''), b.split(',').map(i => parseInt(i))]
}
