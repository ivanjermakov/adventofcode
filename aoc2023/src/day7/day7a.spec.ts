import { readInput, solve } from './day7a'

describe('day7a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(251136060)
    })
    it('should solve example', () => {
        expect(solve(`32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483`)).toEqual(6440)
    })

})
