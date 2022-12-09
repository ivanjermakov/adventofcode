import assert from 'assert'
import {readInput, solve} from './day4a'

xdescribe('day4a', () => {
	it('should example', () => {
		assert.equal(solve('abcdef'), 609043)
	})
	it('should solve', () => {
		assert.equal(solve(readInput()), 254575)
	})
})
