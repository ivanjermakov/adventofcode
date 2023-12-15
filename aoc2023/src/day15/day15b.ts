import { range } from "lodash";
import { holidayHash } from "./day15a";

export interface Lens {
    label: string
    f: number
}

export function solve(input: string): number {
    const boxes: Lens[][] = []
    range(256).forEach(() => boxes.push([]))
    input.split(',').forEach(s => {
        const command = s.includes('-') ? '-' : '='
        const label = s.split(/-|=/)[0]
        const arg = command === '=' ? parseInt(s.at(-1)!) : undefined
        updateBox(boxes[holidayHash(label)], command, label, arg)
    })
    return boxes
        .flatMap((b, i) => b.map((l, j) => (i + 1) * (j + 1) * l.f))
        .reduce((a, b) => a + b, 0)
}

export function updateBox(ls: Lens[], command: string, label: string, arg?: number) {
    const old = ls.findIndex(l => l.label === label)
    if (command === '=' && arg) {
        if (old !== -1) {
            ls[old].f = arg
        } else {
            ls.push({ label, f: arg })
        }
    } else {
        if (old !== -1) {
            ls.splice(old, 1)
        }
    }
}
