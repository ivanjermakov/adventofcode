import { readFileSync } from 'fs'
import { Pos } from '../day10/day10a'

export function readInput(): string {
    return readFileSync('data/day21.txt').toString().trim()
}

export function solve(input: string, steps: number): number {
    const m = input.split('\n').length
    const ps = input
        .split('\n')
        .flatMap((r, i) => r
            .split('')
            .flatMap((c, j) => c !== '#' ? [<Pos>[i, j]] : [])
        )
    const start = ps.find(([i, j]) => input.split('\n')[i][j] === 'S')!
    const psSet = new Set(ps.map(key))
    let res = [start]
    for (let i = 0; i < steps; i++) {
        const nLast: Pos[] = []
        let lastSet = new Set<string>()
        for (const p of res) {
            for (const n of [[-1, 0], [0, 1], [1, 0], [0, -1]]) {
                const neigh = <Pos>[p[0] + n[0], p[1] + n[1]]
                const neighShort = <Pos>[(5 * m + neigh[0]) % m, (5 * m + neigh[1]) % m]
                const neighKey = key(neigh)
                if (!lastSet.has(neighKey) && psSet.has(key(neighShort))) {
                    nLast.push(neigh)
                    lastSet.add(neighKey)
                }
            }
        }
        res = nLast
    }
    return res.length
}

export function key(obj: any): string {
    return JSON.stringify(obj)
}

export function fromKey(str: string): unknown {
    return JSON.parse(str)
}
