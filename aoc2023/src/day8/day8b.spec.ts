import { solve } from '../day8/day8b'
import { readInput } from './day8a'

describe('day8b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(16563603485021)
    })
    it('should solve example', () => {
        expect(solve(`LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)`)).toEqual(6)
    })
})

