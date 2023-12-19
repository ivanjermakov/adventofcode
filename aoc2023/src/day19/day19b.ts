import { Range } from "../day5/day5a"
import { Filter, Rule, parse } from "./day19a"

export interface Part {
    x: Range
    m: Range
    a: Range
    s: Range
}

export function solve(input: string): number {
    const rules = parse(input)[1]
    const p: Part = { x: [1, 4000], m: [1, 4000], a: [1, 4000], s: [1, 4000] }
    return process(p, 'in', rules)
        .map(r => [r.x, r.m, r.a, r.s].flatMap(r => r[1] - r[0] + 1).reduce((a, b) => a * b, 1))
        .reduce((a, b) => a + b, 0)
}

export function process(part: Part, rule: string, rules: Map<string, Rule>): Part[] {
    if (rule === 'A') return [part]
    if (rule === 'R') return []
    const r = rules.get(rule)!
    const ps: Part[] = []
    let p = part
    for (const f of r.filters) {
        const [down, next] = processFilter(p, f)
        if (down) {
            ps.push(...process(down, f.forward, rules))
        }
        if (!next) break
        p = next
    }
    return ps
}

export function processFilter(p: Part, f: Filter): [Part | undefined, Part | undefined] {
    if (!f.condition) return [p, undefined]
    const down = structuredClone(p)
    const next = structuredClone(p)
    const d = <Range>(<any>down)[f.condition.category]
    const n = <Range>(<any>next)[f.condition.category]
    if (f.condition.op === '>') {
        d[0] = Math.max(f.condition.value + 1, d[0])
        n[1] = Math.min(f.condition.value, n[1])
    } else {
        d[1] = Math.min(f.condition.value - 1, n[1])
        n[0] = Math.max(f.condition.value, n[0])
    }
    return [down, next]
}
