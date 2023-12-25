import { readInput, solve } from './day25a'

describe('day25a', () => {
    it.skip('should solve', () => {
        expect(solve(readInput())).toEqual(525264)
    })
    it('should solve example', () => {
        expect(solve(`jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr`)).toEqual(54)
    })
})
