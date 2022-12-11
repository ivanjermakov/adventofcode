import assert from 'assert'
import {readInput, solve} from './day9a'

describe('day9a', () => {
	it('should example', () => {
		assert.equal(solve('London Dublin 464\n' +
			'London Belfast 518\n' +
			'Dublin Belfast 141'), 605)
	})
	it('should solve', () => {
		assert.equal(solve(readInput()), 251)
	})
})
