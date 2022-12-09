import assert from 'assert'
import {readInput} from './dayNa'
import {solve} from './dayNb'

describe('day1b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 42)
	})
})
