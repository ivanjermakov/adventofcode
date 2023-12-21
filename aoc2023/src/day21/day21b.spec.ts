import { solve } from '../day21/day21b'
import { readInput } from './day21a'

describe('day21b', () => {
    it('should solve', () => {
        expect(solve(readInput(), 26501365)).toEqual(608193767979991)
    })
})

