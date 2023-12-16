import { max, range } from "lodash";
import { Pos } from "../day10/day10a";
import { Ray, explored } from "./day16a";

export function solve(input: string): number {
    const g = input.split('\n').map(r => r.split(''))
    const srs = startRays([g.length, g[0].length])
    return max(srs.map(s => explored(g, s)))!
}

/*
 *  vvv
 * >123<
 * >456<
 * >789<
 *  ^^^
 */
export function startRays(size: Pos): Ray[] {
    const top = range(size[0]).map(j => (<Ray>{ pos: [0, j], dir: [1, 0] }))
    const bottom = range(size[0]).map(j => (<Ray>{ pos: [size[0] - 1, j], dir: [-1, 0] }))
    const left = range(size[1]).map(i => (<Ray>{ pos: [i, 0], dir: [0, 1] }))
    const right = range(size[1]).map(i => (<Ray>{ pos: [i, size[1] - 1], dir: [-1, 0] }))
    return [...top, ...bottom, ...left, ...right]
}
