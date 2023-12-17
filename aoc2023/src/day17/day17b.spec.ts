import { solve } from '../day17/day17b'
import { readInput } from './day17a'

describe('day17b', () => {
    it('should solve', () => {
        expect(solve(readInput())).toEqual(1266)
    })
    it('should solve example', () => {
        expect(solve(`2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533`)).toEqual(94)
    })
    it('should solve example', () => {
        expect(solve(`111111111111
999999999991
999999999991
999999999991
999999999991`)).toEqual(71)
    })
})

