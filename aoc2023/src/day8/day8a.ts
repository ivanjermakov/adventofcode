import { readFileSync } from 'fs'

export function readInput(): string {
    return readFileSync('data/day8.txt').toString().trim()
}

export function solve(input: string): number {
    const { moves, map } = parse(input)
    return countSteps('AAA', moves, map)
}

export function countSteps(pos: string, moves: string[], map: Map<string, string[]>): number {
    for (let i = 0; ; i++) {
        const m = moves[i % moves.length]
        pos = map.get(pos)![m === 'L' ? 0 : 1]
        if (pos.endsWith('Z')) {
            return i + 1
        }
    }
}

export function parse(input: string): { moves: string[]; map: Map<string, string[]> } {
    const [moves_, map_] = input.replaceAll(/= \(|,|\)/g, '').split('\n\n')
    const moves = moves_.split('')
    const map = new Map(map_.split('\n').map(l => l.split(' ')).map(l => [l[0], l.slice(1)]))
    return { moves, map }
}
