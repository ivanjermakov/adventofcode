import assert from 'assert'
import {mapScore, readInput, solve} from './day15a'

describe('day15a', () => {
	it('should solve example', () => {
		assert.equal(solve('Butterscotch -1 -2 6 3 8\nCinnamon 2 3 -2 -1 3', mapScore), 62842880)
	})
	it('should solve', () => {
		assert.equal(solve(readInput(), mapScore), 18965440)
	})
})
