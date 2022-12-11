import assert from 'assert'
import {readInput, solve} from './day15a'
import {mapScore} from './day15b'

describe('day15b', () => {
	it('should solve example', () => {
		assert.equal(solve('Butterscotch -1 -2 6 3 8\nCinnamon 2 3 -2 -1 3', mapScore), 57600000)
	})
	it('should solve', () => {
		assert.equal(solve(readInput(), mapScore), 15862900)
	})
})
