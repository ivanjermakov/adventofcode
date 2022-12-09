import assert from 'assert'
import {readInput} from './day2a'
import {solve} from './day2b'

describe('day1b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 3783758)
	})
})
