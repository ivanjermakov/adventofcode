import assert from 'assert'
import {readInput, solve} from './day17a'

describe('day17a', () => {
	it('should solve example', () => {
		assert.equal(solve('20\n15\n10\n5\n5', 25), 4)
	})

	it('should solve', () => {
		assert.equal(solve(readInput(), 150), 1304)
	})
})
