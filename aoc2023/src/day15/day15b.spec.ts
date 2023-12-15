import { solve } from '../day15/day15b'
import { readInput } from './day15a'

describe('day15b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(239484)
    })
    it('should solve example', () => {
        expect(solve(`rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7`)).toEqual(145)
    })
})

