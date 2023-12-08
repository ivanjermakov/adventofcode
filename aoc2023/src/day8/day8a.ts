import { readFileSync } from 'fs'

export function readInput(): string {
    return readFileSync('data/day8.txt').toString().trim()
}

export function solve(input: string): number {
    const { moves, map } = parse(input)
    let pos = 'AAA'
    for (let i = 0; ; i++) {
        const m = moves[i % moves.length]
        pos = map.get(pos)![m === 'L' ? 0 : 1]
        if (pos === 'ZZZ') {
            return i + 1
        }
    }
}

export function parse(input: string): { moves: string[]; map: Map<string, string[]> } {
    const [moves_, map_] = input.split('\n\n')
    const moves = moves_.split('')
    const map = new Map(map_.split('\n').map(l => {
        const ns = [...l.matchAll(/[A-Z]+/g)].map(m => m[0])
        return [ns[0], ns.slice(1)]
    }))
    return { moves, map }
}
