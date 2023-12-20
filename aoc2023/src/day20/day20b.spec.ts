import { solve } from '../day20/day20b'
import { readInput } from './day20a'

describe.skip('day20b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(246313604784977)
    })
})

