import assert from 'assert'
import {readInput, solve} from './day10a'

xdescribe('day10b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput(), 50).length, 5103798)
	})
})
