import { wonCount } from "./day4a"

export function solve(input: string): number {
    const cards = input.split('\n')
    const counts = new Array(cards.length).fill(1)
    cards.forEach((c, i) => {
        const count = wonCount(c)
        for (let j = 0; j < count; j++) {
            counts[i + j + 1] += counts[i]
        }
    })
    return counts.reduce((a, b) => a + b, 0)
}

