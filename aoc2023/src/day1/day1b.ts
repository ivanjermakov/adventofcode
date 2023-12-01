import { parseInt } from "lodash"

export function solve(input: string): number {
    return input.split('\n').map(l => {
        const dgs = l.split('')
            .map((c, i) => {
                const wordDigit = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
                    .map((w, n) => <const>[w, n])
                    .filter(([w,]) => l.slice(i).startsWith(w))
                    .map(([, n]) => n + 1)
                    .at(0)
                return wordDigit ?? parseInt(c)
            })
            .filter(n => !!n)
        return parseInt('' + dgs[0] + dgs.at(-1)!)!
    }).reduce((a, b) => a + b, 0)
}
