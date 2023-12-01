import assert from 'assert'
import { readInput, solve } from './day1a'

describe('day1a', () => {
    it('should solve', () => {
        assert.equal(solve(readInput()), 52974)
    })
})
