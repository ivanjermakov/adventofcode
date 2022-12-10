import assert from 'assert'
import {readInput, solve} from './day7a'

describe('day7a', () => {
	it('should solve example', () => {
		assert.equal(solve('123 -> x\n' +
			'456 -> y\n' +
			'x AND y -> d\n' +
			'x OR y -> e\n' +
			'x LSHIFT 2 -> f\n' +
			'y RSHIFT 2 -> g\n' +
			'NOT x -> h\n' +
			'NOT y -> i', 'h'), 65412)
		assert.equal(solve('123 -> x\n' +
			'456 -> y\n' +
			'x AND y -> d\n' +
			'x OR y -> e\n' +
			'x LSHIFT 2 -> f\n' +
			'y RSHIFT 2 -> g\n' +
			'NOT x -> h\n' +
			'NOT y -> i', 'g'), 114)
	})
	it('should solve', () => {
		assert.equal(solve(readInput(), 'a'), 16076)
	})
})
