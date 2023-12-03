import { readFileSync } from 'fs'

export function readInput(): string {
    return readFileSync('data/day3.txt').toString().trim()
}

export function solve(input: string): number {
    const ok = (c: string) => (c >= '0' && c <= '9') || c === '.'

    const lines = input.split('\n')
    let vs = []
    for (let y = 0; y < lines.length; y++) {
        const line = lines[y]
        let seq = ''
        let bad = false
        // WHY +1 ????????????????????????????????????????????!!!!!!!!!!!!!!!!!!!
        for (let x = 0; x < line.length + 1; x++) {
            const char = line[x]
            if (char >= '0' && char <= '9') {
                const adj = [
                    lines.at(y - 1)?.at(x - 1), lines.at(y - 1)?.at(x), lines.at(y - 1)?.at(x + 1),
                    lines.at(y)?.at(x - 1), lines.at(y)?.at(x + 1),
                    lines.at(y + 1)?.at(x - 1), lines.at(y + 1)?.at(x), lines.at(y + 1)?.at(x + 1),
                ]
                if (adj.every(a => a === undefined || ok(a))) {
                } else {
                    bad = true
                }
                seq += char
            } else {
                if (bad && seq.length > 0) {
                    vs.push(parseInt(seq))
                }
                seq = ''
                bad = false
            }
        }
    }
    return vs.reduce((a, b) => a + b, 0)
}
