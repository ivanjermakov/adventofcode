import assert from 'assert'
import {solve} from './day7a'
import {readInput} from './day7b'

describe('day7b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput(), 'a'), 2797)
	})
})
