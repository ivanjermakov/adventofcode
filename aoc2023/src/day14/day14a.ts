import { readFileSync } from 'fs'
import { isEqual } from 'lodash'

export function readInput(): string {
    return readFileSync('data/day14.txt').toString().trim()
}

export function solve(input: string): number {
    let g = input.split('\n').map(l => l.split(''))
    while (true) {
        const ng = step(g)
        if (isEqual(g, ng)) {
            return score(ng)
        }
        g = ng
    }
}

export function step(grid: string[][]): string[][] {
    const ng = structuredClone(grid)
    for (let i = 0; i < grid.length; i++) {
        for (let j = 0; j < grid[0].length; j++) {
            if (grid[i][j] === 'O') {
                if (i > 0 && grid[i - 1][j] === '.') {
                    ng[i - 1][j] = 'O'
                    ng[i][j] = '.'
                }
            }
        }
    }
    return ng
}

export function score(grid: string[][]): number {
    return grid
        .map((r, i) => r.filter(e => e === 'O').length * (grid.length - i))
        .reduce((a, b) => a + b, 0)
}
