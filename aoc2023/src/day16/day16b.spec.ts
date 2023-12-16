import { solve } from '../day16/day16b'
import { readInput } from './day16a'

describe('day16b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(8244)
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
..//.|....`)).toEqual(51)
    })
})

