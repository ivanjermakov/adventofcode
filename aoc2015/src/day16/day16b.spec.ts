import assert from 'assert'
import {readInput} from './day16a'
import {solve} from './day16b'

describe('day16b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 405)
	})
})
