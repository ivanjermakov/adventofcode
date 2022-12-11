import assert from 'assert'
import {readInput, solve} from './day11a'

xdescribe('day11a', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 'cqjxxyzz')
	})
})
