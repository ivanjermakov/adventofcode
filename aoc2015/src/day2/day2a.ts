import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/day2.txt').toString().trim()
}

export function solve(input: string): number {
	return input.split('\n').map(l => parseDimensions(l)).map(([a, b, c]) => {
		const main = 2 * a * b + 2 * b * c + 2 * c * a
		const add = a * b
		return main + add
	}).reduce((a, b) => a + b, 0)
}

export function parseDimensions(line: string): number[] {
	return line.split('x').map(n => Number(n)).sort((a, b) => a - b)
}
