import { solve } from '../day13/day13b'
import { readInput } from './day13a'

describe('day13b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(31954)
    })
    it('should solve example', () => {
        expect(solve(`#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#`)).toEqual(400)
    })
})

