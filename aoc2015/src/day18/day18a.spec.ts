import assert from 'assert'
import {readInput, solve} from './day18a'

describe('day18a', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 821)
	})
})
