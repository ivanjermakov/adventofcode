import { solve } from '../day12/day12b'
import { readInput } from './day12a'

describe.skip('day12b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(0)
    })
    it('should solve example', () => {
        expect(solve(``)).toEqual(0)
    })
})

