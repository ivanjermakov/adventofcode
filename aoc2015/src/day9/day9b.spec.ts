import assert from 'assert'
import {readInput} from './day9a'
import {solve} from './day9b'

describe('day9b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 898)
	})
})
