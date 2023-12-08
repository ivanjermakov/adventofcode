import { readInput, solve } from './day8a'

describe('day8a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(16897)
    })
    it('should solve example', () => {
        expect(solve(`LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)`)).toEqual(6)
    })
})
