import {parseInput, replaceAt} from './day19a'
import {min} from 'lodash'

export function solve(input: string): number {
	const [rs, m] = parseInput(input)
	return reduceGreedy(rs.map(([t, r]) => [r, t]), m, 'e', 0)
}

export function reduce(rs: [string, string][], m: string, target: string, count: number): number {
	if (m == target) {
		return count
	}
	let ways: number[] = []
	for (let [t, r] of rs) {
		const ms = [...m.matchAll(new RegExp(t, 'g'))].map(m => m.index!)
		for (let matchIdx of ms) {
			const newS = replaceAt(m, matchIdx, t.length, r)
			ways.push(reduce(rs, newS, target, count + 1))
		}
	}
	return min(ways) || Infinity
}

export function reduceGreedy(rs: [string, string][], m: string, target: string, count: number): number {
	if (m == target) {
		return count
	}
	for (let [t, r] of rs) {
		const ms = [...m.matchAll(new RegExp(t, 'g'))].map(m => m.index!)
		if (ms.length > 0) {
			const newS = replaceAt(m, ms[0], t.length, r)
			return reduceGreedy(rs, newS, target, count + 1)
		}
	}
	throw Error
}
