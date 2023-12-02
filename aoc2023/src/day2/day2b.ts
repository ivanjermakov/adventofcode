import { getMaps } from "./day2a"

export function solve(input: string): number {
    const maps = getMaps(input)
    return maps
        .map(ms => {
            const mins = ms.reduce(([mR, mG, mB], m) => {
                mR = Math.max(mR, m.get('red') ?? 0)
                mG = Math.max(mG, m.get('green') ?? 0)
                mB = Math.max(mB, m.get('blue') ?? 0)
                return [mR, mG, mB]
            }, [0, 0, 0])
            return mins.reduce((a, b) => a * b, 1)
        })
        .reduce((a, b) => a + b, 0)
}

