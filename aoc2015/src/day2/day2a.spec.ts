import assert from 'assert'
import {readInput, solve} from './day2a'

describe('dayNa', () => {
	it('should solve example', () => {
		assert.equal(solve('2x3x4'), 58)
		assert.equal(solve('1x1x10'), 43)
	})

	it('should solve', () => {
		assert.equal(solve(readInput()), 1588178)
	})
})
