import { readFileSync } from 'fs'
import { transpose } from '../day11/day11a'

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
    const ss = []
    for (let r = 0; r < grid.length - 1; r++) {
        if (isSymmetrical(r, grid)) {
            ss.push((r + 1) * 100)
        }
    }
    const gridTr = transpose(grid)
    for (let c = 0; c < gridTr.length - 1; c++) {
        if (isSymmetrical(c, gridTr)) {
            ss.push(c + 1)
        }
    }
    return ss
}

export function isSymmetrical(i: number, grid: string[][]): boolean {
    for (let off = 0; off < Math.min(i + 1, grid.length - (i + 1)); off++) {
        const a = grid[i - off].join('')
        const b = grid[i + 1 + off].join('')
        if (a !== b) return false
    }
    return true
}
