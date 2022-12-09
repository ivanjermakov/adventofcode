import {readFileSync} from 'fs'
import {clone, isEqual, uniq, uniqWith} from 'lodash'
import JSON = Mocha.reporters.JSON

export function readInput(): string {
	return readFileSync('data/day3.txt').toString().trim()
}

export function solve(input: string): number {
	let current = [0, 0]
	const visits = [clone(current)]
	for (const [i, c] of input.split('').entries()) {
		if (c == '^') {
			current[1]++
		} else if (c == 'v') {
			current[1]--
		} else if (c == '>') {
			current[0]++
		} else if (c == '<') {
			current[0]--
		} else {
			throw Error('parsing error')
		}
		visits.push(clone(current))
	}
	return uniqWith(visits, isEqual).length
}
