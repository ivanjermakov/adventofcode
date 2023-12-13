import { readFileSync } from 'fs'
import { transpose } from '../day11/day11a'
import { range } from 'lodash'

export function readInput(): string {
    return readFileSync('data/day13.txt').toString().trim()
}

export function solve(input: string): number {
    return input
        .split('\n\n')
        .map(g => g.split('\n').map(l => l.split('')))
        .map(g => symmetryScores(g)[0])
        .reduce((a, b) => a + b, 0)
}

export function symmetryScores(grid: string[][]): number[] {
    const grTr = transpose(grid)
    return [
        ...range(grid.length - 1).filter(r => isSymmetrical(r, grid)).map(r => (r + 1) * 100),
        ...range(grTr.length - 1).filter(c => isSymmetrical(c, grTr)).map(c => c + 1)
    ]
}

export function isSymmetrical(i: number, grid: string[][]): boolean {
    for (let off = 0; off < Math.min(i + 1, grid.length - (i + 1)); off++) {
        const a = grid[i - off].join('')
        const b = grid[i + 1 + off].join('')
        if (a !== b) return false
    }
    return true
}
