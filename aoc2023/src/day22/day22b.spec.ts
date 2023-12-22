import { solve } from '../day22/day22b'
import { readInput } from './day22a'

describe('day22b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(39933)
    })
    it('should solve example', () => {
        expect(solve(`1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9`)).toEqual(7)
    })
})

