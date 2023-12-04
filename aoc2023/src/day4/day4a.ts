import { readFileSync } from 'fs';

export function readInput(): string {
    return readFileSync('data/day4.txt').toString().trim()
}

export function solve(input: string): number {
    return input.split('\n').map(wonCount).map(points).reduce((a, b) => a + b, 0)
}

export function wonCount(card: string): number {
    const [winning, mine] = card.replaceAll('  ', ' ').split(' | ').map(g => g.split(' ').map(s => Number(s.trim())))
    return intersect(mine, winning).length
}

export function points(count: number): number {
    if (count == 0) return 0
    return 2 ** (count - 1)
}

export function intersect<T>(a: T[], b: T[]): T[] {
    return [...new Set(a.filter(i => new Set(b).has(i)))];
}

