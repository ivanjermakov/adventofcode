import { readInput, solve } from './day15a'

describe('day15a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(511257)
    })
    it('should solve example', () => {
        expect(solve(`HASH`)).toEqual(52)
    })
    it('should solve example', () => {
        expect(solve(`rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7`)).toEqual(1320)
    })
})
