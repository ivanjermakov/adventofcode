import { readInput, solve } from './day12a'

describe.skip('day12a', () => {
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
    it('should solve one row', () => {
        expect(solve(`???.### 1,1,3`)).toEqual(1)
        expect(solve(`.??..??...?##. 1,1,3`)).toEqual(4)
        expect(solve(`?#?#?#?#?#?#?#? 1,3,1,6`)).toEqual(1)
        expect(solve(`????.#...#... 4,1,1`)).toEqual(1)
        expect(solve(`????.######..#####. 1,6,5`)).toEqual(4)
        expect(solve(`?###???????? 3,2,1`)).toEqual(10)
        expect(solve(`??????? 2,1`)).toEqual(10)
        expect(solve(`???? 2`)).toEqual(3)
        expect(solve(`???? 1`)).toEqual(4)
    })
})
