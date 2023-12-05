import { readInput, solve } from './day1a'

describe('day1a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(52974)
    })
})
