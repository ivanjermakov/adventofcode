import { readFileSync } from 'fs'
import { printGrid, transpose } from '../day11/day11a'
import { unreachable } from '../util'

export function readInput(): string {
    return readFileSync('data/day13.txt').toString().trim()
}

export function solve(input: string): number {
    return input
        .split('\n\n')
        .map(g => g.split('\n').map(l => l.split('')))
        .map(symmetryScore)
        .reduce((a, b) => a + b, 0)
}

export function symmetryScore(grid: string[][]): number {
    for (let r = 0; r < grid.length - 1; r++) {
        if (isSymmetrical(r, grid)) {
            return (r + 1) * 100
        }
    }
    const gridTr = transpose(grid)
    for (let c = 0; c < gridTr.length - 1; c++) {
        if (isSymmetrical(c, gridTr)) {
            return c + 1
        }
    }
    return unreachable('no symmetry')
}

export function isSymmetrical(i: number, grid: string[][]): boolean {
    for (let off = 0; off < Math.min(i + 1, grid.length - (i + 1)); off++) {
        const a = grid[i - off].join('')
        const b = grid[i + 1 + off].join('')
        if (a !== b) return false
    }
    return true
}
