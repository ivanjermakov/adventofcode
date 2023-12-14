import { readInput, solve } from './day14a'

describe('day14a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(109596)
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
#OO..#....`)).toEqual(136)
    })
})
