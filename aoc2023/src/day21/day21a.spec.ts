import { readInput, solve } from './day21a'

describe('day21a', () => {
    it('should solve', () => {
        expect(solve(readInput(), 64)).toEqual(3658)
    })
    it('should solve example', () => {
        expect(solve(`...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........`, 6)).toEqual(16)
    })
})
