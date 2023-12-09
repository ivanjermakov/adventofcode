import { solve } from '../dayN/dayNb'
import { readInput } from './dayNa'

describe('dayNb', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(0)
    })
    it('should solve example', () => {
        expect(solve(``)).toEqual(0)
    })
})

