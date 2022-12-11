import {readFileSync} from 'fs'
import {orderBy, uniq} from 'lodash'

export function readInput(): string {
	return readFileSync('data/day9.txt').toString().trim()
}

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
	return orderBy(opts)[0]
}

export function parse_dist(input: string): [string, string, number] {
	const [from, to, dist] = input.split(' ')
	return [from, to, parseInt(dist)]
}

export function permute<T>(inputArray: T[]): any {
	const perm = (res: T[], item: any, key: any, arr: T[]): T[] => res.concat(arr.length > 1 && arr.slice(0, key)
		.concat(arr.slice(key + 1))
		.reduce(perm, [])
		.map(perm => [item].concat(perm)) || item)
	return inputArray.reduce(perm, [])
}
