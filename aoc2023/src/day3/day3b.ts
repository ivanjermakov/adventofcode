import { getAdj } from "./day3a"

export function solve(input: string): number {
    const lines = input.split('\n')

    let vs: number[] = []
    let gearPoss = []

    for (let y = 0; y < lines.length; y++) {
        for (let x = 0; x < lines[y].length; x++) {
            if (lines[y][x] === '*') {
                gearPoss.push([y, x])
            }
        }
    }
    gearPoss.forEach(([y, x]) => {
        const ns = [...new Set(getAdj(y, x)
            .map(a => numberAt(input, a)).filter(n => !!n).map(n => n!))]
            .map(n => parseInt(n))
        if (ns.length === 2) {
            vs.push(ns[0] * ns[1])
        }
    })
    return vs.reduce((a, b) => a + b, 0)
}

function numberAt(input: string, [y, x]: [number, number], back = true, forward = true): string | undefined {
    const char = input.split('\n')[y][x]
    let seq = ''
    if (char >= '0' && char <= '9') {
        seq += char
    } else {
        return undefined
    }
    if (back) {
        const prev = numberAt(input, [y, x - 1], true, false)
        if (prev) {
            seq = prev + seq
        }
    }
    if (forward) {
        const next = numberAt(input, [y, x + 1], false, true)
        if (next) {
            seq += next
        }
    }
    return seq
}
