import { solve } from './day6a'

describe('day6a', () => {
    it('should solve', () => {
        expect(solve([[44, 283], [70, 1134], [70, 1134], [80, 1491]])).toEqual(219849)
    })
    it('should solve example', () => {
        expect(solve([[7, 9], [15, 40], [30, 200]])).toEqual(288)
    })
})
