import assert from 'assert'
import {readInput, solve} from './day3a'

describe('day3a', () => {
	it('should solve example', () => {
		assert.equal(solve('>'), 2)
		assert.equal(solve('^>v'), 4)
	})
	it('should solve', () => {
		assert.equal(solve(readInput()), 2081)
	})
})
