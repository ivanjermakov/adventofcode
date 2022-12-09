import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/day1.txt').toString().trim()
}

export function solve(input: string): number {
	return input
		.split('')
		.map(c => c == '(' ? 1 : c == ')' ? -1 : NaN)
		.reduce((a, b) => a + b, 0)
}
