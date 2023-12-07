import { readFileSync } from 'fs'

export const ranks: string[] = '23456789TJQKA'.split('')
export const hands = <const>['high', 'one', 'two', 'three', 'full-house', 'four', 'five']

export type Hand = typeof hands[number]

export function readInput(): string {
    return readFileSync('data/day7.txt').toString().trim()
}

export function solve(input: string): number {
    const gs = input.split('\n').map(l => <const>[l.split(' ')[0].split(''), parseInt(l.split(' ')[1])])
    gs.sort((g1, g2) => {
        const o1 = hands.indexOf(getHand(g1[0]))
        const o2 = hands.indexOf(getHand(g2[0]))
        if (o1 == o2) {
            for (let i = 0; i < g1[0].length; i++) {
                let c1 = ranks.indexOf(g1[0][i])
                let c2 = ranks.indexOf(g2[0][i])
                if (c1 !== c2) return c1 - c2
            }
            return 0
        }
        return o1 - o2
    })
    return gs.map((g, i) => g[1] * (i + 1)).reduce((a, b) => a + b, 0)
}

export function getHand(cs: string[]): Hand {
    const dist = new Map<string, number>()
    for (let c of cs) {
        dist.set(c, dist.get(c) ? dist.get(c)! + 1 : 1)
    }
    if ([...dist.values()].some(d => d === 5)) return 'five'
    if ([...dist.values()].some(d => d === 4)) return 'four'
    const has3 = [...dist.values()].some(d => d === 3)
    const has2 = [...dist.values()].some(d => d === 2)
    if (has3 && has2) return 'full-house'
    if (has3) return 'three'
    if ([...dist.values()].filter(d => d === 2).length === 2) return 'two'
    if (has2) return 'one'
    return 'high'
}

export function high(cs: string[]): string {
    const cp = [...cs]
    cp.sort((a, b) => ranks.indexOf(b) - ranks.indexOf(a))
    return cp[0]
}
