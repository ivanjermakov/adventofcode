import { Pos } from "../day10/day10a";
import { posEq } from "../day17/day17a";
import { key } from "../day21/day21a";

export interface Node<T> {
    n: T
    nodes: Node<T>[]
}

export function solve(input: string): number {
    const g = input.split('\n').map(l => l.split(''))
    const cs = new Map<string, string>(
        g.flatMap((r, i) => r.flatMap((c, j) => c === '#' ? [] : [[key([i, j]), c]]))
    )
    const n = g.length
    const m = g[0].length
    const vs: Pos[] = []
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < m; j++) {
            if (g[i][j] !== '#') {
                if (adj([i, j]).filter(p => cs.has(key(p))).length > 2) {
                    vs.push([i, j])
                }
            }
        }
    }
    vs.push([0, 1], [n - 1, m - 2])

    const es = new Map<string, [Pos, number][]>(vs.map(v => [key(v), []]))
    for (const v of vs) {
        let q = [v]
        const seen = new Set(key(v))
        let dist = 0
        while (q.length > 0) {
            const nq = []
            dist += 1
            for (const c of q) {
                for (const a of adj(c).filter(a => !seen.has(key(a)) && cs.has(key(a)))) {
                    seen.add(key(a))
                    if (vs.find(v_ => posEq(v_, a))) {
                        es.get(key(v))!.push([a, dist])
                    } else {
                        nq.push(a)
                    }
                }
            }
            q = nq
        }
    }

    const ans = { ans: 0 }
    dfs([0, 1], [n - 1, m - 2], es, new Set(), 0, ans)
    return ans.ans - 2
}

export function dfs(cur: Pos, target: Pos, es: Map<string, [Pos, number][]>, path: Set<string>, total: number, ans: { ans: number }) {
    if (posEq(cur, target)) {
        if (total > ans.ans) {
            ans.ans = total
        }
    } else {
        for (const [a, d] of es.get(key(cur))!) {
            if (!path.has(key(a))) {
                path.add(key(a))
                dfs(a, target, es, path, total + d, ans)
                path.delete(key(a))
            }
        }
    }
}

export function adj(p: Pos): Pos[] {
    return [[-1, 0], [0, 1], [1, 0], [0, -1]]
        .map(n => <Pos>[p[0] + n[0], p[1] + n[1]])
}
