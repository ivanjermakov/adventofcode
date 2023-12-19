import { readFileSync } from 'fs'
import { unreachable } from '../util'

export interface Part {
    x: number
    m: number
    a: number
    s: number
}

export interface Rule {
    name: string
    filters: Filter[]
}

export interface Filter {
    condition?: Condition
    forward: string
}

export interface Condition {
    category: string
    op: string
    value: number
}

export function readInput(): string {
    return readFileSync('data/day19.txt').toString().trim()
}

export function solve(input: string): number {
    const [parts, rules] = parse(input)
    return parts
        .map(p => <const>[p, process(p, 'in', rules)])
        .filter(([, accepted]) => accepted)
        .map(([p]) => p.x + p.m + p.a + p.s)
        .reduce((a, b) => a + b, 0)
}

export function parse(input: string): [Part[], Map<string, Rule>] {
    const [rules, parts] = input.split('\n\n')
    return [parseParts(parts), parseRules(rules)]
}

export function parseParts(input: string): Part[] {
    return input.split('\n').map(p => {
        const [x, m, a, s] = p
            .replaceAll(/{|}/g, '')
            .replaceAll(/.=/g, '')
            .split(',')
            .map(i => parseInt(i))
        return { x, m, a, s }
    })
}

export function parseRules(input: string): Map<string, Rule> {
    return new Map(input.split('\n').map(r => {
        let [name, conds] = r.split('{')
        conds = conds.replaceAll('}', '')
        const filters = conds.split(',').map(f => {
            const [c, fw] = f.split(':')
            if (!fw) return { forward: c }

            const [category, v] = c.split(/>|</g)
            const op = c.includes('>') ? '>' : '<'

            return {
                condition: { category, op, value: parseInt(v) },
                forward: fw
            }
        })
        return <const>[name, { name, filters }]
    }))
}

export function process(part: Part, rule: string, rules: Map<string, Rule>): boolean {
    const r = rules.get(rule)!
    const fw = probe(part, r)
    if (fw === 'A') return true
    if (fw === 'R') return false
    return process(part, fw, rules)
}

export function probe(part: Part, rule: Rule): string {
    for (const f of rule.filters) {
        if (!f.condition || checkCondition(part, f.condition)) return f.forward
    }
    return unreachable()
}

export function checkCondition(part: Part, c: Condition): boolean {
    return c.op === '>'
        ? ((<any>part)[c.category as any]) > c.value
        : ((<any>part)[c.category]) < c.value
}
