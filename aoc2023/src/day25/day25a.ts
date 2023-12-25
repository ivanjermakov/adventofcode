import { readFileSync } from 'fs'

export interface Edge {
    u: string
    v: string
    name: string
}

export interface Graph {
    vs: Set<string>
    es: Edge[]
}

export function readInput(): string {
    return readFileSync('data/day25.txt').toString().trim()
}

export function solve(input: string): number {
    const g = buildGraph(input)
    while (true) {
        const ng = structuredClone(g)
        while (ng.vs.size > 2) {
            const e = structuredClone(ng.es[Math.floor(Math.random() * ng.es.length)])
            contract(e, ng)
        }
        if (ng.es.length < 4) {
            return [...ng.vs].map(v => v.split(',').length).reduce((a, b) => a * b, 1)
        }
    }
}

export function buildGraph(input: string): Graph {
    const insts = input.split('\n').map(l => {
        const [n, adj] = l.split(': ')
        return <const>[n, adj.split(' ')]
    })
    const vs = new Set(insts.flatMap(i => [i[0], ...i[1]]))
    const es: Edge[] = []
    insts.forEach(i => {
        i[1].forEach(a => es.push({ u: i[0], v: a, name: [i[0], a].join() }))
    })
    return { vs, es }
}

/**
 * Remove an edge from a graph, merging nodes
 */
export function contract(e: Edge, g: Graph) {
    g.vs.delete(e.u)
    g.vs.delete(e.v)
    const n = [e.u, e.v].join()
    g.vs.add(n)
    g.es = g.es.filter(ed => ![ed.u, ed.v].every(v => [e.u, e.v].includes(v)))
    g.es.forEach(ed => {
        if ([e.u, e.v].includes(ed.u)) {
            ed.u = n
        }
        if ([e.u, e.v].includes(ed.v)) {
            ed.v = n
        }
    })
}

export function adjacent(v: string, g: Graph): Edge[] {
    return g.es.filter(e => e.u === v || e.v === v)
}

