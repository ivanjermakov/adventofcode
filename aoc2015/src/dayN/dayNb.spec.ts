import assert from 'assert'
import {readInput} from './dayNa'
import {solve} from './dayNb'

xdescribe('dayNb', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 42)
	})
})
