import assert from 'assert'
import {readInput, readInputExample, solve} from './day13a'

describe('day13a', () => {
	it('should solve example', () => {
		assert.equal(solve(readInputExample()), 330)
	})
	xit('should solve', () => {
		assert.equal(solve(readInput()), 664)
	})
})
