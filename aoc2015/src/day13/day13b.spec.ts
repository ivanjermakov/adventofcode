import assert from 'assert'
import {readInput} from './day13a'
import {solve} from './day13b'

xdescribe('day13b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 640)
	})
})
