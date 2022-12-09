import assert from 'assert'
import {readInput} from './day4a'
import {solve} from './day4b'

xdescribe('day4b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 1038736)
	})
})
