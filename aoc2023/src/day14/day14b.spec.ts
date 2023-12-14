import { solve } from '../day14/day14b'
import { readInput } from './day14a'

describe('day14b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(96105)
    })
    it('should solve example', () => {
        expect(solve(`O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....`, 1_000_000_000)).toEqual(64)
    })
})

