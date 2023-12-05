import { readFileSync } from 'fs'
import { chunk } from 'lodash'

export type Range = [number, number]

export function readInput(): string {
    return readFileSync('data/day5.txt').toString().trim()
}

export function solve(input: string): number {
    let sections = input.split('\n\n')
    let seeds = sections[0].split(' ').slice(1).map(s => parseInt(s))
    let maps = sections.slice(1).map(section => section.split('\n').slice(1).map(l => l.split(' ').map(s => parseInt(s))))
    return seeds
        .map(seed => maps.reduce((v, m) => map(m, v), seed))
        .reduce((a, b) => Math.min(a, b), Infinity)
}

export function map(m: number[][], value: number): number {
    for (let rec of m) {
        if (value >= rec[1] && value < rec[1] + rec[2]) {
            return rec[0] + (value - rec[1])
        }
    }
    return value
}

export function parse(input: string): { seeds: Range[], maps: number[][][] } {
    let sections = input.split('\n\n')
    let seeds = chunk(sections[0].split(' ').slice(1).map(s => parseInt(s)), 2).map(([st, s]) => <Range>[st, st + s - 1])
    let maps = sections.slice(1).map(section => section.split('\n').slice(1).map(l => l.split(' ').map(s => parseInt(s))))
    return { seeds, maps }
}
