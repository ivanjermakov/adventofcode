import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/day12.txt').toString().trim()
}

export function solve(input: string): number {
	const ms = [...input.matchAll(/([+-]?)\d+/g)]
	const ns = ms.map(s => parseInt(s[0]))
	return ns.reduce((a, b) => a + b, 0)
}
