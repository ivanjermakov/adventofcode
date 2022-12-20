import assert from 'assert'
import {readInput, solve} from './day16a'

describe('day16a', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 103)
	})
})
