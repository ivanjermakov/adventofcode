import { readInput, solve } from './day16a'

describe('day16a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(7623)
    })
    it('should solve example', () => {
        expect(solve(`.|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|....`)).toEqual(46)
    })
})
