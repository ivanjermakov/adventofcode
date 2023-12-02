import { readInput, solve } from './day2a'

describe('day2a', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(2683)
    })

    it('should solve example', () => {
        expect(solve(`3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green`)).toEqual(8)
    })
})
