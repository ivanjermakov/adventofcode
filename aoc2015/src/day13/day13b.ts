import {orderBy, uniq} from 'lodash'
import {permute} from '../day9/day9a'
import {score} from './day13a'

export function solve(input: string): number {
	let desires = input.split('\n').map(l => l.split(' '))
	const guests = [...uniq(desires.flatMap(([g1, _, g2]) => [g1, g2])), 'Me']
	let combs = permute(guests)
	let scores = combs.map(c => score(c, desires))
	return orderBy(scores).reverse()[0]
}
