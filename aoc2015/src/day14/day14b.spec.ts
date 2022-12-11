import assert from 'assert'
import {readInput} from './day14a'
import {solve} from './day14b'

describe('day14b', () => {
	it('should solve example', () => {
		assert.equal(solve('14 10 127\n16 11 162', 1000), 689)
	})
	it('should solve', () => {
		assert.equal(solve(readInput(), 2503), 1084)
	})
})
