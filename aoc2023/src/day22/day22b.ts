import { Brick, key, mkSupportMap, parse, step } from "./day22a";

export function solve(input: string): number {
    const bs: Brick[] = parse(input)
    const ps = new Set(bs.flatMap(b => b.cubes).map(key))

    let changed = true;
    while (changed) {
        changed = step(bs, ps).size > 0
    }

    const supportMap = mkSupportMap(bs)

    const disints = [...supportMap.keys()].filter(k => {
        const cont = [...supportMap.values()].filter(vs => vs.has(k))
        return cont.length > 0 && cont.some(vs => vs.size === 1);
    })

    let res = 0
    for (const disint of disints) {
        const bs_ = structuredClone(bs).filter((_, i) => i !== disint)
        const ps_ = new Set(bs_.flatMap(b => b.cubes).map(key))
        res += countFallen(bs_, ps_)
    }
    return res
}

export function countFallen(bs: Brick[], ps: Set<string>): number {
    let changed = new Set()
    while (changed) {
        const nf = step(bs, ps)
        if (nf.size === 0) break
        nf.forEach(n => changed.add(n))
    }
    return changed.size
}
