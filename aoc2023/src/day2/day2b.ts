export function solve(input: string): number {
    const maps = input.split('\n').map(l => {
        const maps: Map<string, number>[] = []
        l.split('; ')
            .forEach(g => {
                maps.push(new Map())
                g.split(', ').forEach(p => {
                    const ws = p.split(' ')
                    maps.at(-1)!.set(ws[1], (maps.at(-1)!.get(ws[1]) ?? 0) + parseInt(ws[0]))
                })
            })
        return maps
    })
    return maps.map((ms, i) => <const>[ms, i])
        .map(([ms,]) => {
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

