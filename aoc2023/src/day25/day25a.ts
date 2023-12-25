import { readFileSync } from 'fs'
import { uniqWith } from 'lodash'
import { unreachable } from '../util'

export type Graph = Map<string, Set<string>>

export function readInput(): string {
    return readFileSync('data/day25.txt').toString().trim()
}

export function solve(input: string): number {
    const g = buildGraph(input)
    const es = edges(g)
    const combs = select3(es.length)
    for (const [i, j, k] of combs) {
        const ng = structuredClone(g);
        [es[i], es[j], es[k]].forEach(e => removeEdge(e[0], e[1], ng))
        const comps = components(ng)
        if (comps.length > 1) {
            return comps.map(c => c.length).reduce((a, b) => a * b, 1)
        }
    }
    return unreachable('no solution')
}

export function buildGraph(input: string): Graph {
    const insts = input.split('\n').map(l => {
        const [n, adj] = l.split(': ')
        return <const>[n, adj.split(' ')]
    })
    const nodes = new Set(insts.flatMap(i => [i[0], ...i[1]]))
    const g = new Map([...nodes.keys()].map(n => [n, new Set<string>()]))
    insts.forEach(i => {
        i[1].forEach(a => g.get(i[0])!.add(a))
        i[1].forEach(a => g.get(a)!.add(i[0]))
    })
    return g
}

export function adjacent(a: string, b: string, g: Graph): boolean {
    return g.get(a)!.has(b) || g.get(b)!.has(a)
}

export function removeEdge(a: string, b: string, g: Graph): boolean {
    const foundB = g.get(a)!.delete(b)
    const foundA = g.get(b)!.delete(a)
    return foundB || foundA
}

export function components(g: Graph): string[][] {
    const left = [...g.keys()]
    const cs = []
    while (left.length > 0) {
        const c: string[] = []
        cs.push(c)
        let ns = [left.at(-1)!]
        while (ns.length > 0) {
            const n = ns.pop()!
            if (!left.includes(n)) continue
            c.push(n)
            left.splice(left.indexOf(n), 1)
            ns.push(...g.get(n)!)
        }
    }
    return cs
}

export function edges(g: Graph): [string, string][] {
    const es: [string, string][] = []
    for (const k of g.keys()) {
        g.get(k)!.forEach(a => es.push([k, a]))
    }
    return uniqWith(es, (a, b) => (a[0] === b[0] && a[1] === b[1]) || (a[0] === b[1] && a[1] === b[0]))
}

export function* select3(size: number): Generator<[number, number, number]> {
    for (let i = 0; i < size - 2; i++) {
        for (let j = i + 1; j < size - 1; j++) {
            for (let k = j + 1; k < size; k++) {
                yield [i, j, k]
            }
        }
    }
}
