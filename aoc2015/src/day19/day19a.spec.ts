import assert from 'assert'
import {readInput, solve} from './day19a'

describe('day19a', () => {
	it('should solve', () => {
		assert.equal(solve(readInput()), 518)
	})
})
