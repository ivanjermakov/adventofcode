import { readFileSync } from 'fs'

export function readInput(): string {
    return readFileSync('data/day8.txt').toString().trim()
}

export function solve(input: string): number {
    const inp = input.split('\n\n')
    const moves = inp[0].split('')
    const map = new Map(inp[1].split('\n').map(l => {
        const v = l.split('=')[1].split(', ')
        return [l.split(' ')[0], [v[0].slice(2), v[1].slice(0, -1)]]
    }))
    let i = 0
    let pos = 'AAA'
    while (true) {
        const m = moves[i % moves.length]
        pos = map.get(pos)![m === 'L' ? 0 : 1]
        if (pos === 'ZZZ') {
            return i + 1
        }
        i++
    }
}
