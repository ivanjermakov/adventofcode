import assert from 'assert'
import { readInput, solve } from './day3a'

describe('day3a', () => {
    it('should solve', () => {
        assert.equal(solve(readInput()), 535351)
    })

    it('should solve example', () => {
        assert.equal(solve(`467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
`), 4361)
    })
})
