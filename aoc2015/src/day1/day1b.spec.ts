import assert from 'assert'
import {readInput} from './day1a'
import {solve} from './day1b'

describe('day1b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 1783)
	})
})
