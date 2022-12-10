import assert from 'assert'
import {readInput} from './day8a'
import {solve} from './day8b'

describe('day8b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 2074)
	})
})
