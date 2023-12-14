import { readFileSync } from 'fs'
import { isEqual } from 'lodash'

export type Direction = 'N' | 'E' | 'S' | 'W'

export function readInput(): string {
    return readFileSync('data/day14.txt').toString().trim()
}

export function solve(input: string): number {
    let g = input.split('\n').map(l => l.split(''))
    const ng = roll(g, 'N')
    return score(ng)
}

export function roll(g: string[][], dir: Direction): string[][] {
    while (true) {
        const og = structuredClone(g)
        step(g, dir)
        if (isEqual(g, og)) {
            return g
        }
    }
}

export function step(grid: string[][], dir: Direction) {
    for (let i = 0; i < grid.length; i++) {
        for (let j = 0; j < grid[0].length; j++) {
            if (grid[i][j] === 'O') {
                if (dir === 'N' && i > 0 && grid[i - 1][j] === '.') {
                    grid[i - 1][j] = 'O'
                    grid[i][j] = '.'
                }
                else if (dir === 'E' && j < grid[0].length - 1 && grid[i][j + 1] === '.') {
                    grid[i][j + 1] = 'O'
                    grid[i][j] = '.'
                }
                else if (dir === 'S' && i < grid.length - 1 && grid[i + 1][j] === '.') {
                    grid[i + 1][j] = 'O'
                    grid[i][j] = '.'
                }
                else if (dir === 'W' && j > 0 && grid[i][j - 1] === '.') {
                    grid[i][j - 1] = 'O'
                    grid[i][j] = '.'
                }
            }
        }
    }
}

export function score(grid: string[][]): number {
    return grid
        .map((r, i) => r.filter(e => e === 'O').length * (grid.length - i))
        .reduce((a, b) => a + b, 0)
}
