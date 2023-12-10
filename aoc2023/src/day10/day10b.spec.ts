import { solve } from '../day10/day10b'
import { readInput } from './day10a'

describe.skip('day10b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(0)
    })
    it('should solve example', () => {
        expect(solve(`.....
.S-7.
.|.|.
.L-J.
.....`)).toEqual(4)
    })
})

