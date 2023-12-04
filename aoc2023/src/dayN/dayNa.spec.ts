import { readInput, solve } from './dayNa'

describe.skip('dayNa', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(0)
    })
})
