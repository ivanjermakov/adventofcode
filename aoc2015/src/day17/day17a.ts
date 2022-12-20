import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/day17.txt').toString().trim()
}

export function solve(input: string, total: number): number {
	const ns = input.split('\n').map(l => parseInt(l))
	const res = powerSet(ns).filter(s => s.reduce((a, b) => a + b, 0) == total)
	return res.length
}

export function powerSet<T>(theArray: T[]): T[][] {
	return theArray.reduce(
		(subsets: T[][], value: T) => subsets.concat(
			subsets.map(set => [value, ...set])
		),
		[[]]
	)
}
