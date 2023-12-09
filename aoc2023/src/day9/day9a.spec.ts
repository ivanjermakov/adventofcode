import { readInput, solve } from './day9a'

describe('day9a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(1934898178)
    })
    it('should solve example', () => {
        expect(solve(`0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45`)).toEqual(114)
    })
})
