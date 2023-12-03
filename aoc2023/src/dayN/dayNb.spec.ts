import { solve } from '../dayN/dayNb'
import { readInput } from './dayNa'

describe.skip('dayNb', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(0)
    })
})

