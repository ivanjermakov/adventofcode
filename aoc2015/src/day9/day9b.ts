import {parse_dist, permute} from './day9a'
import {orderBy, uniq} from 'lodash'

export function solve(input: string): number {
	const dists = input.split('\n').map(l => parse_dist(l))
	const cities = uniq(dists.flatMap(([f, t, _]) => [f, t]))
	const combs: string[][] = permute(cities)
	const getDist = (p1: string, p2: string): number => {
		return dists
			.filter(([f, t, d]) => (f === p1 && t === p2) || (f === p2 && t === p1))
			.map(([f, t, d]) => d)[0]
	}
	const opts = combs.map(comb => {
		return comb.slice(1)
			.map((wp, i) => {
				return getDist(comb[i], wp)
			})
			.reduce((a, b) => a + b, 0)
	})
	return orderBy(opts).reverse()[0]
}
