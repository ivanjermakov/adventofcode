import { readFileSync } from 'fs'

export function readInput(): string {
    return readFileSync('data/day2.txt').toString().trim()
}

export function solve(input: string): number {
    const maps = getMaps(input)
    return maps.map((ms, i) => <const>[ms, i])
        .filter(([ms,]) => ms.every(m =>
            (!m.get('red') || m.get('red')! <= 12) &&
            (!m.get('green') || m.get('green')! <= 13) &&
            (!m.get('blue') || m.get('blue')! <= 14)
        ))
        .map(([, i]) => i + 1)
        .reduce((a, b) => a + b, 0)
}

export function getMaps(input: string): Map<string, number>[][] {
    return input.split('\n').map(l => {
        const maps: Map<string, number>[] = []
        l.split('; ')
            .forEach(g => {
                maps.push(new Map())
                g.split(', ').forEach(p => {
                    const ws = p.split(' ')
                    const oldV = (maps.at(-1)!.get(ws[1]) ?? 0)
                    maps.at(-1)!.set(ws[1], oldV + parseInt(ws[0]))
                })
            })
        return maps
    })
}
