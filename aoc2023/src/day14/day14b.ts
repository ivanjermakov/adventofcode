import { roll, score } from "./day14a"

const cache = new Map<string, string>()

export function solve(input: string, lim: number = 1_000_000_000): number {
    let g = input
    for (let n = 0; n < lim; n++) {
        g = rollCached(g)
    }
    return score(g.split('\n').map(r => r.split('')))
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
