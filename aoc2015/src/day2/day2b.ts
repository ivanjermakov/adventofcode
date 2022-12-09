import {parseDimensions} from './day2a'

export function solve(input: string): number {
	return input.split('\n').map(l => parseDimensions(l)).map(([a, b, c]) => {
		const main = 2 * a + 2 * b
		const add = a * b * c
		return main + add
	}).reduce((a, b) => a + b, 0)
}
