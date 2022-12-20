import assert from 'assert'
import {readInput, solve} from './dayNa'

xdescribe('dayNa', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 0)
	})
})
