import { readInput, solve } from './day13a'

describe('day13a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(30487)
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
#....#..#`)).toEqual(405)
    })
})
