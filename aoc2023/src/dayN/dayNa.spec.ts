import assert from 'assert'
import { readInput, solve } from './dayNa'

describe.skip('dayNa', () => {
    it('should solve', () => {
        assert.equal(solve(readInput()), 0)
    })
})
