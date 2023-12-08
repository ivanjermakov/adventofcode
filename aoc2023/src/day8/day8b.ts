import { parse } from "./day8a"

export function solve(input: string): number {
    const { moves, map } = parse(input)
    let ps = [...map.keys()].filter(k => k.endsWith('A'))
    let ttz: number[] = new Array(ps.length).fill(0)
    for (let n = 0; n < ps.length; n++) {
        for (let i = 0; ; i++) {
            const m = moves[i % moves.length]
            ps[n] = map.get(ps[n])![m === 'L' ? 0 : 1]
            if (ps[n].endsWith('Z')) {
                ttz[n] = i + 1
                break
            }
        }
    }
    return ttz.reduce((a, b) => leastCommonMultiple(a, b), 1)
}

export function leastCommonMultiple(a: number, b: number): number {
    return (a * b) / greatestCommonDivisor(a, b);
}

export function greatestCommonDivisor(a: number, b: number): number {
    return !b ? a : greatestCommonDivisor(b, a % b);
}
