import {distAfter} from './day14a'
import {orderBy} from 'lodash'

export function solve(input: string, t: number): number {
	const deerList = input.split('\n').map(l => l.split(' ').map(t => parseInt(t)))
	let scores: number[] = new Array(deerList.length).fill(0)
	let dists: number[] = new Array(deerList.length).fill(0)
	for (let i = 1; i < t; i++) {
		dists = deerList.map(d => distAfter(d, i))
		const leadingDist = orderBy(dists).reverse()[0]
		scores = scores.map((s, i) => dists[i] === leadingDist ? s + 1 : s)
	}
	return orderBy(scores).reverse()[0]
}
