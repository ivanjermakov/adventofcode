import { solve } from '../day12/day12b'
import { readInput } from './day12a'

describe('day12b', () => {
    it('should solve', () => {
        expect(solve(readInput(), 5)).toEqual(17788038834112)
    })
    it('should solve example', () => {
        expect(solve(`???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1`, 5)).toEqual(525152)
    })
    it('should solve one row', () => {
        expect(solve(`???.### 1,1,3`, 5)).toEqual(1)
        expect(solve(`.??..??...?##. 1,1,3`, 5)).toEqual(16384)
        expect(solve(`?#?#?#?#?#?#?#? 1,3,1,6`, 5)).toEqual(1)
        expect(solve(`????.#...#... 4,1,1`, 5)).toEqual(16)
        expect(solve(`????.######..#####. 1,6,5`, 5)).toEqual(2500)
        expect(solve(`?###???????? 3,2,1`, 5)).toEqual(506250)
    })
})

