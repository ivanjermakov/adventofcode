import assert from 'assert'
import {readInput} from './day3a'
import {solve} from './day3b'

describe('day3b', () => {
	it('should example', () => {
		assert.equal(solve('^v'), 3)
		assert.equal(solve('^>v<'), 3)
		assert.equal(solve('^v^v^v^v^v'), 11)
	})
	it('should solve', () => {
		assert.equal(solve(readInput()), 2341)
	})
})
