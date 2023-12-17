import { heat } from "./day17a"

export function solve(input: string): number {
    const g = input.split('\n').map(r => r.split('').map(c => parseInt(c)))
    return heat([g.length - 1, g[0].length - 1], g, 4, 10)
}

