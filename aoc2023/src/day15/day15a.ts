import { readFileSync } from 'fs'

export function readInput(): string {
    return readFileSync('data/day15.txt').toString().trim()
}

export function solve(input: string): number {
    return input.split(',').map(holidayHash).reduce((a, b) => a + b, 0)
}

export function holidayHash(s: string): number {
    return s.split('').reduce((acc, c) => {
        acc += c.charCodeAt(0)
        acc *= 17
        acc %= 256
        return acc
    }, 0)
}
