import assert from 'assert'
import {readInput} from './day5a'
import {solve} from './day5b'

describe('day5b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 51)
	})
})
