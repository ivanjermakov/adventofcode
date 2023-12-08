import { countSteps, parse } from "./day8a"

export function solve(input: string): number {
    const { moves, map } = parse(input)
    return [...map.keys()].filter(k => k.endsWith('A'))
        .map(p => countSteps(p, moves, map))
        .reduce((a, b) => leastCommonMultiple(a, b), 1)
}

export function leastCommonMultiple(a: number, b: number): number {
    return (a * b) / greatestCommonDivisor(a, b);
}

export function greatestCommonDivisor(a: number, b: number): number {
    return !b ? a : greatestCommonDivisor(b, a % b);
}
