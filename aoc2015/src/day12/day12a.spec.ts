import assert from 'assert'
import {readInput, solve} from './day12a'

describe('day12a', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 111754)
	})
})
