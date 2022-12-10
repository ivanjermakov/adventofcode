import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/day5.txt').toString().trim()
}

export function solve(input: string): number {
	return input.split('\n').filter(line => {
		const a = line.split('').filter(c => 'aeiou'.includes(c)).length >= 3
		const b = !!line.match(/(.)(\1)/)
		const c = !line.match(/(ab)|(cd)|(pq)|(xy)/)
		return a && b && c
	}).length
}
