import { PriorityQueue } from '@datastructures-js/priority-queue'
import { readFileSync } from 'fs'
import { Pos } from '../day10/day10a'
import { unreachable } from '../util'

export interface Node {
    pos: Pos
    heat: number
    dirCount: number
    dir?: Pos
}

export function readInput(): string {
    return readFileSync('data/day17.txt').toString().trim()
}

export function solve(input: string): number {
    const g = input.split('\n').map(r => r.split('').map(c => parseInt(c)))
    return heat([g.length - 1, g[0].length - 1], g)
}

export function heat(target: Pos, g: number[][], min: number = 0, max: number = 3): number {
    const q = new PriorityQueue<Node>((a, b) => a.heat - b.heat)
    q.push({ pos: [0, 0], heat: 0, dirCount: 0 })
    const visited = new Set<string>()

    while (q.size() > 0) {
        let u = q.pop()!
        if (u.dirCount >= min - 1 && posEq(u.pos, target)) return u.heat

        const key = [u.pos[0], u.pos[1], u.dir?.[0], u.dir?.[1], u.dirCount].join()
        if (visited.has(key)) continue
        visited.add(key)

        for (let nDir of [[-1, 0], [0, 1], [1, 0], [0, -1]].map((dir) => <Pos>dir)) {
            const nPos = <Pos>[u.pos[0] + nDir[0], u.pos[1] + nDir[1]]
            if (nPos[0] < 0 || nPos[0] > g.length - 1 || nPos[1] < 0 || nPos[1] > g[0].length - 1) continue
            if (posEq(u.dir, [-nDir[0], -nDir[1]])) continue
            const nDirCount = posEq(u.dir, nDir) ? u.dirCount + 1 : 0
            if (u.dir && !posEq(u.dir, nDir) && u.dirCount < min - 1) continue
            if (nDirCount >= max) continue
            q.push({
                pos: nPos,
                heat: u.heat + g[nPos[0]][nPos[1]],
                dirCount: nDirCount,
                dir: nDir
            })
        }
    }

    return unreachable('no path')
}

export function posEq(a: Pos | undefined, b: Pos | undefined): boolean {
    if (!a || !b) return false
    return a[0] === b[0] && a[1] === b[1]
}
