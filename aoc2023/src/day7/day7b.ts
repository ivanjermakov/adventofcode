import { getHand, hands } from "./day7a";

export const ranks: string[] = 'J23456789TQKA'.split('')

export function solve(input: string): number {
    const gs = input.split('\n').map(l => <const>[l.split(' ')[0], parseInt(l.split(' ')[1])])
    gs.sort((g1, g2) => cmp(g1[0].split(''), g2[0].split(''), true))
    return gs.map((g, i) => g[1] * (i + 1)).reduce((a, b) => a + b, 0)
}

export function cmp(g1: string[], g2: string[], enhance = false): number {
    const o1 = hands.indexOf(enhance ? getHand(enhanceJ(g1)) : getHand(g1))
    const o2 = hands.indexOf(enhance ? getHand(enhanceJ(g2)) : getHand(g2))
    if (o1 == o2) {
        for (let i = 0; i < g1.length; i++) {
            let c1 = ranks.indexOf(g1[i])
            let c2 = ranks.indexOf(g2[i])
            if (c1 !== c2) return c1 - c2
        }
        return 0
    }
    return o1 - o2
}

export function enhanceJ(cs: string[]): string[] {
    if (!cs.includes('J')) return cs

    const dist = new Map<string, number>()
    for (let c of cs) {
        dist.set(c, dist.get(c) ? dist.get(c)! + 1 : 1)
    }
    dist.delete('J')

    // all Js is always all As
    if (dist.size === 0) return 'AAAAA'.split('')

    const distA = [...dist.entries()]
    distA.sort((a, b) => {
        const d = b[1] - a[1]
        if (d == 0) {
            ranks.indexOf(b[0]) - ranks.indexOf(a[0])
        }
        return d;
    })
    const mostFreq = distA.length ? distA[0][0] : 'J'
    const jps = cs.map((c, i) => <const>[c, i]).filter(([c,]) => c === 'J').map(([, i]) => i)

    const best = [...cs]
    for (let i of jps) {
        best[i] = mostFreq
    }
    return best!
}
