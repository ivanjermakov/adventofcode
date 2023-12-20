import { readInput, solve } from './day20a'

describe('day20a', () => {
    it('should solve', () => {
        expect(solve(readInput(), 1000)).toEqual(818649769)
    })
    it('should solve example', () => {
        expect(solve(`broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a`, 1)).toEqual(32)
    })
    it('should solve example', () => {
        expect(solve(`broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a`, 1000)).toEqual(32000000)
    })
    it('should solve example', () => {
        expect(solve(`broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output`, 1000)).toEqual(11687500)
    })
})
