import assert from 'assert'
import {readInput, solve} from './day14a'

describe('day14a', () => {
	it('should solve example', () => {
		assert.equal(solve('14 10 127\n16 11 162', 1000), 1120)
	})
	it('should solve', () => {
		assert.equal(solve(readInput(), 2503), 2696)
	})
})
