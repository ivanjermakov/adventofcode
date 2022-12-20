import assert from 'assert'
import {solve} from './day20a'

describe('day20a', () => {
	it('should solve', () => {
		assert.equal(solve(70), 4)
	})
	it('should solve', () => {
		assert.equal(solve(29_000_000), 665280)
	})
})
