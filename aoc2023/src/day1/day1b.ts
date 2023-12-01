export function solve(input: string): number {
    const data = input.split('\n').map(l => {
        const dgs = l.split('')
            .map((c, i) => {
                const nxt = l.slice(i)
                if (nxt.startsWith('one')) return 1
                if (nxt.startsWith('two')) return 2
                if (nxt.startsWith('three')) return 3
                if (nxt.startsWith('four')) return 4
                if (nxt.startsWith('five')) return 5
                if (nxt.startsWith('six')) return 6
                if (nxt.startsWith('seven')) return 7
                if (nxt.startsWith('eight')) return 8
                if (nxt.startsWith('nine')) return 9
                return parseInt(c)
            })
            .filter(n => !!n)
        return Number('' + dgs[0] + dgs.at(-1)!)
    }).reduce((a, b) => a + b, 0)
    return data
}
