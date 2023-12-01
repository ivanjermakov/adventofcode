import { readInput } from './day1a'
import { solve } from './day1b'

describe('day1b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(53340)
    })
})

