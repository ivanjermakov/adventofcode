import assert from 'assert'
import {simulate, solve} from './day21a'

describe('day21a', () => {
	it('should simulate example', () => {
		assert.equal(simulate([8, 5, 5], [12, 7, 2]), true)
	})
	it('should solve', () => {
		assert.equal(solve([103, 9, 2]), 121)
	})
})
