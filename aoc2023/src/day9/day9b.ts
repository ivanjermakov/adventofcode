import { rows } from "./day9a";

export function solve(input: string): number {
    return input.split('\n')
        .map(l => l.split(' ').map(n => parseInt(n)))
        .map(s => extrapolate(rows(s)))
        .reduce((a, b) => a + b, 0)
}

export function extrapolate(rows: number[][]): number {
    for (let r = rows.length - 1; r >= 0; r--) {
        rows[r].unshift(rows[r][0] - (rows.at(r + 1)?.[0] ?? 0))
    }
    return rows[0][0]
}
