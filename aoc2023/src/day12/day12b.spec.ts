import { solve } from '../day12/day12b'
import { readInput } from './day12a'

describe('day12b', () => {
    it.skip('should solve', () => {
        expect(solve(readInput(), 5)).toEqual(0)
    })
    it('should solve example', () => {
        expect(solve(`???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1`, 5)).toEqual(525152)
    })
})

