import { readInput, solve } from './day10a'

describe('day10a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(7173)
    })
    it('should solve example', () => {
        expect(solve(`.....
.S-7.
.|.|.
.L-J.
.....`)).toEqual(4)
        expect(solve(`
..F7.
.FJ|.
SJ.L7
|F--J
LJ...`)).toEqual(8)
    })
})
