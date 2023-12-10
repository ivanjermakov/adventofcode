import { readFileSync } from 'fs'
import { assert, unreachable } from '../util'

export type Pos = [number, number]

export function readInput(): string {
    return readFileSync('data/day10.txt').toString().trim()
}

export function solve(input: string): number {
    const grid = input.split('\n').map(l => l.split(''))
    const row = grid.map((l, i) => <const>[l, i]).find(([l,]) => l.includes('S'))![1]
    const col = grid[row].indexOf('S')
    const pos: [number, number] = [row, col]
    const path = traverse(pos, grid)
    // pretty(path, grid)
    return path.length / 2
}

export function pretty(path: Pos[], grid: string[][]) {
    for (let i = 0; i < grid.length; i++) {
        let line = ''
        for (let j = 0; j < grid[i].length; j++) {
            if (path.find(p => p[0] === i && p[1] === j)) {
                line += grid[i][j]
            } else {
                line += '.'
            }
        }
        console.log(
            line
                .replaceAll('|', '│')
                .replaceAll('-', '─')
                .replaceAll('L', '└')
                .replaceAll('J', '┘')
                .replaceAll('7', '┐')
                .replaceAll('F', '┌')
                .replaceAll('S', '█')
        )
    }
}

export function traverse(pos: Pos, grid: string[][], last?: Pos): Pos[] {
    const v = grid[pos[0]][pos[1]]
    if (last) {
        if (v === 'S') return []
        const n = route([pos[0] - last[0], pos[1] - last[1]], v)
        assert(!!n)
        const nPos = <Pos>[pos[0] + n![0], pos[1] + n![1]]
        return [pos, ...traverse(nPos, grid, pos)]
    } else {
        const adjIdx: Pos[] = [[-1, 0], [0, 1], [1, 0], [0, -1]]
        for (const adj of adjIdx) {
            const a = grid.at(pos[0] + adj[0])?.at(pos[1] + adj[1])
            if (!a) continue
            const n = route(adj, a)
            if (!n) continue
            const nPos = <Pos>[pos[0] + adj[0], pos[1] + adj[1]]
            return [pos, ...traverse(nPos, grid, pos)]
        }
    }
    return unreachable('no path')
}

function route([y, x]: Pos, c: string): Pos | undefined {
    switch (c) {
        case `|`: {
            if (y === 1 && x === 0) return [1, 0]
            if (y === -1 && x === 0) return [-1, 0]
            return undefined
        }
        case `-`: {
            if (y === 0 && x === 1) return [0, 1]
            if (y === 0 && x === -1) return [0, -1]
            return undefined
        }
        case `L`: {
            if (y === 1 && x === 0) return [0, 1]
            if (y === 0 && x === -1) return [-1, 0]
            return undefined
        }
        case `J`: {
            if (y === 1 && x === 0) return [0, -1]
            if (y === 0 && x === 1) return [-1, 0]
            return undefined
        }
        case `7`: {
            if (y === -1 && x === 0) return [0, -1]
            if (y === 0 && x === 1) return [1, 0]
            return undefined
        }
        case `F`: {
            if (y === -1 && x === 0) return [0, 1]
            if (y === 0 && x === -1) return [1, 0]
            return undefined
        }
        default: return undefined
    }
}
