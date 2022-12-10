import assert from 'assert'
import {readInput} from './day6a'
import {solve} from './day6b'

describe('day6b', () => {
	it('should solve example', () => {
		assert.equal(solve('on 0,0 0,0'), 1)
		assert.equal(solve('toggle 0,0 999,999'), 2000000)
	})
	it('should solve', () => {
		assert.equal(solve(readInput()), 15343601)
	})
})
