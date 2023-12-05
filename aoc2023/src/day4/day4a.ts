import { readFileSync } from 'fs';

export function readInput(): string {
    return readFileSync('data/day4.txt').toString().trim()
}

export function solve(input: string): number {
    return input
        .split('\n')
        .map(wonCount)
        .filter(c => c !== 0)
        .map(c => 2 ** (c - 1))
        .reduce((a, b) => a + b, 0)
}

export function wonCount(card: string): number {
    const [winning, mine] = card.split('|').map(g => g.trim().split(/\s+/).map(s => parseInt(s)))
    return intersect(mine, winning).length
}

export function intersect<T>(a: T[], b: T[]): T[] {
    const bSet = new Set(b)
    return [...new Set(a.filter(e => bSet.has(e)))];
}

