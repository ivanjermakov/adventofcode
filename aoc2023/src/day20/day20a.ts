import { readFileSync } from 'fs'
import { unreachable } from '../util'

export function readInput(): string {
    return readFileSync('data/day20.txt').toString().trim()
}

export interface Signal {
    from: string
    high: boolean
    to: string
}

export type Module = Broadcast | FlipFlop | Conjunction | Button

export interface Broadcast {
    type: 'broadcast'
}

export interface FlipFlop {
    type: 'flip-flop'
    on: boolean
}

export interface Conjunction {
    type: 'conjunction'
    state: Map<string, boolean>
}

export interface Button {
    type: 'button'
}

export function solve(input: string, count: number): number {
    const routes = new Map<string, string[]>(input.split('\n').map(l => {
        const [left, right] = l.split(' -> ')
        const n = left.replace(/[%&]/g, '')
        const dests = right.split(', ')
        return [n, dests]
    }))
    routes.set('button', ['broadcaster'])
    const modules = new Map<string, Module>(input.split('\n').map(l => l.split(' ')[0]).map(m => {
        if (m.startsWith('button')) {
            return ['button', { type: 'button' }]
        }
        if (m.startsWith('broadcaster')) {
            return ['broadcaster', { type: 'broadcast' }]
        }
        if (m.startsWith('%')) {
            return [m.slice(1), { type: 'flip-flop', on: false }]
        }
        if (m.startsWith('&')) {
            const n = m.slice(1)
            const state = new Map<string, boolean>(
                [...routes.entries()].filter(([, v]) => v.includes(n)).map(([k,]) => [k, false])
            )
            return [n, { type: 'conjunction', state }]
        }
        return unreachable()
    }))
    modules.set('button', { type: 'button' })
    // console.log(routes)
    // console.log(modules)

    const signals: Signal[] = []
    for (let i = 0; i < count; i++) {
        let active: Signal[] = [{ from: 'button', high: false, to: 'broadcaster' }]
        while (active.length > 0) {
            signals.push(...active)
            active = active.flatMap(s => handleSignal(s, routes, modules))
        }
    }

    // console.log(signals)
    return signals.filter(s => s.high).length * signals.filter(s => !s.high).length
}

export function handleSignal(signal: Signal, routes: Map<string, string[]>, modules: Map<string, Module>): Signal[] {
    const m = modules.get(signal.to)
    if (!m) return []
    const r = routes.get(signal.to)!
    switch (m.type) {
        case 'button': { return [] }
        case 'broadcast': { return r.map(to => ({ from: signal.to, high: signal.high, to })) }
        case 'conjunction': {
            m.state.set(signal.from, signal.high)
            const high = ![...m.state.values()].every(v => v)
            return r.map(to => ({ from: signal.to, high, to }))
        }
        case 'flip-flop': {
            if (signal.high) return []
            m.on = !m.on
            return r.map(to => ({ from: signal.to, high: m.on, to }))
        }
    }
}
