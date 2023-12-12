import { readInput, solve } from './day12a'

describe('day12a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(7163)
    })
    it('should solve example', () => {
        expect(solve(`???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1`)).toEqual(21)
    })
})
