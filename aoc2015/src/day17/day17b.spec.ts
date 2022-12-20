import assert from 'assert'
import {readInput} from './day17a'
import {solve} from './day17b'

describe('day17b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput(), 150), 18)
	})
})
