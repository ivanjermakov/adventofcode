import { Signal, handleSignal, parse } from "./day20a"

export function solve(input: string): number {
    const { routes, modules } = parse(input)
    for (let i = 0; ; i++) {
        let signals: Signal[] = [{ from: 'button', high: false, to: 'broadcaster' }]
        while (signals.length > 0) {
            signals = signals.flatMap(s => handleSignal(s, routes, modules))
            if (signals.filter(s => s.to === 'rx' && !s.high).length > 0) return i
        }
    }
}

