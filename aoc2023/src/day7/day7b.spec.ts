import { cmp, enhanceJ, solve } from '../day7/day7b'
import { readInput } from './day7a'

describe('day7b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(249400220)
    })

    it('should solve example', () => {
        expect(solve(`32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483`)).toEqual(5905)
    })

    it('should find best swap', () => {
        expect(enhanceJ('JK5KQ'.split('')).join('')).toEqual('KK5KQ')
        expect(enhanceJ('JJJKK'.split('')).join('')).toEqual('KKKKK')
        expect(enhanceJ('JJJJJ'.split('')).join('')).toEqual('AAAAA')
        expect(enhanceJ('AKQTJ'.split('')).join('')).toEqual('AKQTA')
    })

    it('should cmp', () => {
        expect(cmp('JKKK2'.split(''), 'QQQQ2'.split(''))).toBeLessThan(0)
        expect(cmp('2AAAA'.split(''), '33332'.split(''))).toBeLessThan(0)
        expect(cmp('77788'.split(''), '77888'.split(''))).toBeLessThan(0)
    })
})

