import { readFileSync } from 'fs'
import { isEqual, uniqWith } from 'lodash'
import { Pos } from '../day10/day10a'
import { unreachable } from '../util'

export interface Ray {
    pos: Pos
    dir: Pos
}

export function readInput(): string {
    return readFileSync('data/day16.txt').toString().trim()
}

export function solve(input: string): number {
    const g = input.split('\n').map(r => r.split(''))
    const hist: Ray[] = []
    let rs: Ray[] = [{ pos: [0, 0], dir: [0, 1] }]
    while (rs.length > 0) {
        hist.push(...rs)
        console.log(hist.length)
        rs = rs
            .flatMap(r => propagate(r, g[r.pos[0]][r.pos[1]]))
            .filter(r => r.pos[0] >= 0 && r.pos[0] < g.length && r.pos[1] >= 0 && r.pos[1] < g[0].length)
            .filter(r => !hist.find(h => isEqual(r, h)))
    }
    return uniqWith(hist, (a, b) => isEqual(a.pos, b.pos)).length
}

export function propagate(ray: Ray, cell: string): Ray[] {
    switch (cell) {
        case '.': {
            return [{ pos: [ray.pos[0] + ray.dir[0], ray.pos[1] + ray.dir[1]], dir: ray.dir }]
        }
        case '\\': {
            const dir = <Pos>[ray.dir[1], ray.dir[0]]
            return [{ pos: [ray.pos[0] + dir[0], ray.pos[1] + dir[1]], dir }]
        }
        case '/': {
            const dir = <Pos>[-ray.dir[1], -ray.dir[0]]
            return [{ pos: [ray.pos[0] + dir[0], ray.pos[1] + dir[1]], dir }]
        }
        case '-': {
            if (ray.dir[0] === 0) {
                return [{ pos: [ray.pos[0] + ray.dir[0], ray.pos[1] + ray.dir[1]], dir: ray.dir }]
            } else {
                return [...propagate(ray, '\\'), ...propagate(ray, '/')]
            }
        }
        case '|': {
            if (ray.dir[1] === 0) {
                return [{ pos: [ray.pos[0] + ray.dir[0], ray.pos[1] + ray.dir[1]], dir: ray.dir }]
            } else {
                return [...propagate(ray, '\\'), ...propagate(ray, '/')]
            }
        }
    }
    return unreachable()
} 
