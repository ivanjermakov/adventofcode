import assert from 'assert'
import {readInput, solve} from './day10a'

describe('day10a', () => {
	it('should solve', () => {
		assert.equal(solve(readInput(), 40).length, 360154)
	})
})
