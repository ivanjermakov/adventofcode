import { readFileSync } from 'fs'

export type Hand = 'five' | 'four' | 'full-house' | 'three' | 'two' | 'one' | 'high'

export function readInput(): string {
    return readFileSync('data/day7.txt').toString().trim()
}

export function solve(input: string): number {
    const gs = input.split('\n').map(l => <const>[l.split(' ')[0], parseInt(l.split(' ')[1])])
    gs.sort((g1, g2) => {
        const o1 = ordHand(getHand(g1[0].split('')))
        const o2 = ordHand(getHand(g2[0].split('')))
        if (o1 == o2) {
            for (let i = 0; i < g1[0].split('').length; i++) {
                let c1 = ordCard(g1[0].split('')[i])
                let c2 = ordCard(g2[0].split('')[i])
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
    const has5 = [...dist.values()].some(d => d === 5)
    const has4 = [...dist.values()].some(d => d === 4)
    const has3 = [...dist.values()].some(d => d === 3)
    const has2p = [...dist.values()].filter(d => d === 2).length === 2
    const has2 = [...dist.values()].some(d => d === 2)
    if (has5) return 'five'
    if (has4) return 'four'
    if (has3 && has2) return 'full-house'
    if (has3) return 'three'
    if (has2p) return 'two'
    if (has2) return 'one'
    return 'high'
}

export function ordHand(h: Hand): number {
    switch (h) {
        case 'five': return 7
        case 'four': return 6
        case 'full-house': return 5
        case 'three': return 4
        case 'two': return 3
        case 'one': return 2
        case 'high': return 1
    }
}

export function ordCard(c: string): number {
    switch (c) {
        case 'A': return 14
        case 'K': return 13
        case 'Q': return 12
        case 'J': return 11
        case 'T': return 10
        default: return parseInt(c)
    }
}

export function high(cs: string[]): string {
    const cp = [...cs]
    cp.sort((a, b) => ordCard(b) - ordCard(a))
    return cp[0]
}
