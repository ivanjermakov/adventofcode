import { solve as solveA } from './day21a'

export function solve(input: string, steps: number): number {
    const m = input.split('\n').length
    const a0 = solveA(input, 65)
    const a1 = solveA(input, 65 + 131)
    const a2 = solveA(input, 65 + 2 * 131)
    const [a, b, c] = simplifiedLagrange(a0, a1, a2)
    const n = Math.floor(steps / m)
    return (a * (n ** 2)) + (b * n) + c
}

const simplifiedLagrange = (a0: number, a1: number, a2: number): [number, number, number] => {
    return [a0 / 2 - a1 + a2 / 2, -3 * (a0 / 2) + 2 * a1 - a2 / 2, a0,]
};
