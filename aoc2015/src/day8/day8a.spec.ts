import assert from 'assert'
import {readInput, solve} from './day8a'

describe('day8a', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 1342)
	})
})
