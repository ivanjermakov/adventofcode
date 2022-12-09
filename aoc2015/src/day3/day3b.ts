import {clone, isEqual, uniqWith} from 'lodash'

export function solve(input: string): number {
	let santa = [0, 0]
	let robo = [0, 0]
	const visits = [clone(santa), clone(robo)]


	for (const [i, c] of input.split('').entries()) {
		const d = delta(c)
		if (i % 2 == 0) {
			santa[0] += d[0]
			santa[1] += d[1]
			visits.push(clone(santa))
		} else {
			robo[0] += d[0]
			robo[1] += d[1]
			visits.push(clone(robo))
		}
	}
	return uniqWith(visits, isEqual).length
}

function delta(c: string): [number, number] {
	if (c == '^') {
		return [0, 1]
	} else if (c == 'v') {
		return [0, -1]
	} else if (c == '>') {
		return [1, 0]
	} else if (c == '<') {
		return [-1, 0]
	} else {
		throw Error('parsing error')
	}
}
