import { readFileSync } from 'fs'

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

export function solve(input: string): number {
    const bs: Brick[] = input.split('\n').map(b => {
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

    let changed = true;
    while (changed) {
        changed = step(bs)
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

export function step(bs: Brick[]): boolean {
    let changed = false
    for (let i = 0; i < bs.length; i++) {
        const b = bs[i]
        if (b.cubes.find(c => c.z === 1)) continue
        if (b.cubes.every(c => !bs.find((b_, i_) => i !== i_ && brickContains(b_, { x: c.x, y: c.y, z: c.z - 1 })))) {
            b.cubes.forEach(c => c.z--)
            changed = true
        }
    }
    return changed
}

export function key(pos: Pos3): string {
    return JSON.stringify(pos)
}

export function brickContains(brick: Brick, pos: Pos3): boolean {
    return brick.cubes.some(p => posEq(p, pos))
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
