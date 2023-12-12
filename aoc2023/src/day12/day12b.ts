import { parse, solveRowCached } from './day12a'

export function solve(input: string, copies: number): number {
    return input
        .split('\n')
        .map(l => {
            const [row, groups] = parse(l)
            return <const>[repeat(row, copies, '?'), repeat(groups, copies)]
        })
        .map(([row, groups], i) => {
            const res = solveRowCached(row, groups)
            return res
        })
        .reduce((a, b) => a + b, 0)
}

export function repeat<T>(a: T[], n: number, separator?: T): T[] {
    const res = []
    for (let i = 0; i < n; i++) {
        res.push(...a)
        if (separator && i !== n - 1) {
            res.push(separator)
        }
    }
    return res
}
