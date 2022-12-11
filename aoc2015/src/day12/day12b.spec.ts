import assert from 'assert'
import {readInput} from './day12a'
import {solve} from './day12b'

describe('day12b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 65402)
	})
})
