import assert from 'assert'
import {readInput, solve} from './day5a'

describe('day5a', () => {
	it('should solve example', () => {
		assert.equal(solve('ugknbfddgicrmopn'), 1)
		assert.equal(solve('aaa'), 1)
		assert.equal(solve('jchzalrnumimnmhp'), 0)
		assert.equal(solve('haegwjzuvuyypxyu'), 0)
		assert.equal(solve('dvszwmarrgswjxmb'), 0)
	})
	it('should solve', () => {
		assert.equal(solve(readInput()), 236)
	})
})
