import { readFileSync } from 'fs'
import { min } from 'lodash'

export interface Pos3 {
    x: number
    y: number
    z: number
}

export interface Brick {
    cubes: Pos3[]
}

export function readInput(): string {
    return readFileSync('data/day22.txt').toString().trim()
}

export function parse(input: string): Brick[] {
    return input.split('\n').map(b => {
        const [s, e] = b.split('~')
        const [sx, sy, sz] = s.split(',').map(c => parseInt(c))
        const [ex, ey, ez] = e.split(',').map(c => parseInt(c))
        const cubes = []
        for (let x = sx; x <= ex; x++) {
            for (let y = sy; y <= ey; y++) {
                for (let z = sz; z <= ez; z++) {
                    cubes.push({ x, y, z })
                }
            }
        }
        return { cubes }
    })
}

export function solve(input: string): number {
    const bs: Brick[] = parse(input)
    const ps = new Set(bs.flatMap(b => b.cubes).map(key))

    let changed = true;
    while (changed) {
        changed = step(bs, ps)
    }

    let supportMap = new Map<number, Set<number>>()
    for (let i = 0; i < bs.length; i++) {
        supportMap.set(i, new Set())
        for (let j = 0; j < bs.length; j++) {
            if (i === j) continue
            if (isSupportedBy(bs[i], bs[j])) {
                supportMap.get(i)!.add(j)
            }
        }
    }
    return [...supportMap.keys()]
        .filter(k => [...supportMap.values()]
            .filter(vs => vs.has(k))
            .every(vs => vs.size > 1))
        .length
}

export function step(bs: Brick[], ps: Set<string>): boolean {
    let changed = false
    for (let i = 0; i < bs.length; i++) {
        const b = bs[i]
        const minZ = min(b.cubes.map(c => c.z))!
        if (b.cubes.filter(c => c.z === minZ).every(c => {
            return c.z > 1 && !ps.has(key({ x: c.x, y: c.y, z: c.z - 1 }))
        })) {
            b.cubes.forEach(c => {
                ps.delete(key(c))
                c.z--
                ps.add(key(c))
            })
            changed = true
        }
    }
    return changed
}

export function key(pos: Pos3): string {
    return JSON.stringify(pos)
}

export function posEq(a: Pos3 | undefined, b: Pos3 | undefined): boolean {
    if (!a || !b) return false
    return a.x === b.x && a.y === b.y && a.z === b.z
}

export function isSupportedBy(a: Brick, b: Brick): boolean {
    for (const ca of a.cubes) {
        for (const cb of b.cubes) {
            if (ca.x === cb.x && ca.y === cb.y && ca.z === cb.z + 1) {
                return true
            }
        }
    }
    return false
}
