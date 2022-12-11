import {readFileSync} from 'fs'
import {permute} from '../day9/day9a'
import {orderBy, uniq} from 'lodash'

export function readInputExample(): string {
	return readFileSync('data/day13e.txt').toString().trim()
}

export function readInput(): string {
	return readFileSync('data/day13.txt').toString().trim()
}

export function solve(input: string): number {
	let desires = input.split('\n').map(l => l.split(' '))
	const guests = uniq(desires.flatMap(([g1, _, g2]) => [g1, g2]))
	let combs = permute(guests)
	let scores = combs.map(c => score(c, desires))
	return orderBy(scores).reverse()[0]
}

export function score(comb: string[], desires: string[][]): number {
	let score = 0
	for (let i = 0; i < comb.length; i++) {
		const g1 = comb[i]
		const g2 = comb[(i + 1) % comb.length]
		score += find_score(g1, g2, desires) || 0
		score += find_score(g2, g1, desires) || 0
	}
	return score
}

function find_score(g1: string, g2: string, desires: string[][]): number | undefined {
	const desire = desires.find(([p1, , p2]) => p1 === g1 && p2 === g2)
	return desire ? parseInt(desire[1]) : undefined
}
