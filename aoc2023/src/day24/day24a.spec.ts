import { readInput, solve } from './day24a'

describe('day24a', () => {
    it('should solve', () => {
        expect(solve(readInput(), [200_000_000_000_000, 400_000_000_000_000])).toEqual(16779)
    })
    it('should solve example', () => {
        expect(solve(`19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3`, [7, 27])).toEqual(2)
    })
})
