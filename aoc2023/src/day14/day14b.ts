import { roll } from "./day14a"

const cache = new Map<string, string>()

export function solve(input: string, iter: number = 1_000_000_000): number {
    let g = input
    const keys: string[] = []
    for (let n = 0; n < iter; n++) {
        g = rollCached(g)
        const i = keys.indexOf(g)
        if (i !== -1) {
            const cycle = keys.slice(i)
            const finalKey = cycle[(iter - i - 1) % cycle.length]
            return score(finalKey)
        }
        keys.push(g)
    }
    return score(g)
}

export function rollCached(input: string): string {
    const key = input
    const cached = cache.get(key)
    if (cached) {
        return cached
    }
    let g = input.split('\n').map(r => r.split(''))
    g = roll(g, 'N')
    g = roll(g, 'W')
    g = roll(g, 'S')
    g = roll(g, 'E')
    const res = g.flatMap(r => r.join('')).join('\n')
    cache.set(key, res)
    return res
}

export function freq<T>(a: T[]): Map<T, number> {
    const m = new Map()
    for (const e of a) {
        const old = m.get(e)
        m.set(e, old ? old + 1 : 1)
    }
    return m
}

export function score(input: string): number {
    const grid = input
        .split('\n').map(r => r.split(''))
    return grid
        .map((r, i) => r.filter(e => e === 'O').length * (grid.length - i))
        .reduce((a, b) => a + b, 0)
}
