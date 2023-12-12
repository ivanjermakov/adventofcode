import { readFileSync } from 'fs'
import { BaseN } from 'js-combinatorics'
import { isEqual } from 'lodash'

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

export function solveRow(row: string[], groups: number[]): number {
    const unknownCount = row.filter(e => e === '?').length
    const unknownCombs = [...new BaseN('.#', unknownCount)]
    return unknownCombs
        .map(comb => replaceUnknown(row, comb))
        .filter(r => isEqual(getGroups(r), groups))
        .length
}

export function replaceUnknown(row: string[], comb: string[]): string[] {
    const c = [...comb]
    return row.map(e => e === '?' ? c.shift()! : e)
}

export function getGroups(row: string[]): number[] {
    return row.join('').split(/\.+/).map(e => e.length).filter(n => n !== 0)
}

export function parse(row: string): [string[], number[]] {
    const [a, b] = row.split(' ')
    return [a.split(''), b.split(',').map(i => parseInt(i))]
}
