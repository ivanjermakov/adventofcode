import assert from 'assert'
import {readInput, solve} from './dayNa'

describe('dayNa', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 42)
	})
})
