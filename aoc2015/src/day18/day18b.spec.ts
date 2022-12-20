import assert from 'assert'
import {solve} from './day18b'
import {readInput} from './day18a'

describe('day18b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 886)
	})
})
