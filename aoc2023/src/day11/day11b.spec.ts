import { solve } from '../day11/day11b'
import { readInput } from './day11a'

describe.skip('day11b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(0)
    })
    it('should solve example', () => {
        expect(solve(``)).toEqual(0)
    })
})

