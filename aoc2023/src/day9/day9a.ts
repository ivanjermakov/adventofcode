import { readFileSync } from 'fs'

export function readInput(): string {
    return readFileSync('data/day9.txt').toString().trim()
}

export function solve(input: string): number {
    return input.split('\n')
        .map(l => l.split(' ').map(n => parseInt(n)))
        .map(s => extrapolate(rows(s)))
        .reduce((a, b) => a + b, 0)
}

export function rows(seq: number[]): number[][] {
    const rows = [seq]
    for (let r = 0; ; r++) {
        const row = []
        for (let i = 0; i < rows[r].length - 1; i++) {
            row.push(rows[r][i + 1] - rows[r][i])
        }
        rows.push(row)
        if (row.every(e => e === 0)) {
            break
        }
    }
    return rows
}

export function extrapolate(rows: number[][]): number {
    for (let r = rows.length - 1; r >= 0; r--) {
        rows[r].push((rows.at(r + 1)?.at(-1) ?? 0) + rows[r].at(-1)!)
    }
    return rows[0].at(-1)!
}
