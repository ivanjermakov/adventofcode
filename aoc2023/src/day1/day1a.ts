import { readFileSync } from 'fs'

export function readInput(): string {
    return readFileSync('data/day1.txt').toString().trim()
}

export function solve(input: string): number {
    const data = input.split('\n').map(l => {
        const dgs = l.split('').map(c => parseInt(c)).filter(n => !!n)
        return Number('' + dgs[0] + dgs.at(-1)!)
    }).reduce((a, b) => a + b, 0)
    return data
}
