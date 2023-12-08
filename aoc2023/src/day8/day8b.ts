export function solve(input: string): number {
    const inp = input.split('\n\n')
    const moves = inp[0].split('')
    const map = new Map(inp[1].split('\n').map(l => {
        const v = l.split('=')[1].split(', ')
        return [l.split(' ')[0], [v[0].slice(2), v[1].slice(0, -1)]]
    }))
    let ps = [...map.keys()].filter(k => k.endsWith('A'))
    let ttz: number[] = new Array(ps.length).fill(0)
    for (let n = 0; n < ps.length; n++) {
        let i = 0
        while (true) {
            const m = moves[i % moves.length]
            ps[n] = map.get(ps[n])![m === 'L' ? 0 : 1]
            if (ps[n].endsWith('Z')) {
                ttz[n] = i + 1
                break
            }
            i++
        }
    }
    return ttz.reduce((a, b) => leastCommonMultiple(a, b), 1)
}

export function leastCommonMultiple(a: number, b: number): number {
    return (a * b) / greatestCommonDivisor(a, b);
}

export function greatestCommonDivisor(a: number, b: number): number {
    return !b ? a : greatestCommonDivisor(b, a % b);
}
