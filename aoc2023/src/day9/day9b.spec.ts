import { solve } from '../day9/day9b'
import { readInput } from './day9a'

describe('day9b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(1129)
    })
    it('should solve example', () => {
        expect(solve(`0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45`)).toEqual(2)
    })
})

