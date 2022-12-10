import assert from 'assert'
import {readInput, solve} from './day6a'

describe('day6a', () => {
	it('should solve example', () => {
		assert.equal(solve('on 0,0 2,2'), 9)
		assert.equal(solve('on 1,1 2,2'), 4)
		assert.equal(solve('toggle 0,0 2,2'), 9)
		assert.equal(solve('toggle 0,0 999,0'), 1000)
		assert.equal(solve('on 0,0 999,999 \ntoggle 0,0 999,0'), 999000)
	})
	it('should solve', () => {
		assert.equal(solve(readInput()), 400410)
	})
})
