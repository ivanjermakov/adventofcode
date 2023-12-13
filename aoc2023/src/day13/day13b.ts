import { unreachable } from "../util";
import { symmetryScores } from "./day13a";

export function solve(input: string): number {
    return input
        .split('\n\n')
        .map(g => g.split('\n').map(l => l.split('')))
        .map((g, n) => {
            const origScore = symmetryScores(g)[0]
            for (let i = 0; i < g.length; i++) {
                for (let j = 0; j < g[0].length; j++) {
                    const ng = structuredClone(g)
                    ng[i][j] = ng[i][j] !== '#' ? '#' : ':'
                    const altScore = symmetryScores(ng).find(s => s !== origScore)
                    if (altScore) return altScore
                }
            }
            return unreachable(`no alt score at grid ${n}`)
        })
        .reduce((a, b) => a + b, 0)
}

