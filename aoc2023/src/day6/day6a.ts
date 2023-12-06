export function solve(races: [number, number][]): number {
    return races.map(r => ways(r[0], r[1])).reduce((a, b) => a * b, 1)
}

function ways(duration: number, record: number): number {
    let n = 0
    for (let i = 0; i < duration; i++) {
        if (dist(i, duration) > record) {
            n++
        }
    }
    return n
}

function dist(hold: number, duration: number): number {
    return hold * (duration - hold)
}

