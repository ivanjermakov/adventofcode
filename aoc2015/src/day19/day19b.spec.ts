import assert from 'assert'
import {readInput} from './day19a'
import {solve} from './day19b'

describe('day19b', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 200)
	})
})
