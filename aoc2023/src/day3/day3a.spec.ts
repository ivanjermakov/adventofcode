import { readInput, solve } from './day3a'

describe('day3a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(535351)
    })

    it('should solve example', () => {
        expect(solve(`467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
`)).toEqual(4361)
    })
})
