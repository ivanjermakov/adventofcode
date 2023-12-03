import { solve } from '../day3/day3b'
import { readInput } from './day3a'

describe('day3b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(87287096)
    })

    it('should solve example', () => {
        expect(solve(`467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
`)).toEqual(467835)
    })
})

