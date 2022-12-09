import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/dayN.txt').toString().trim()
}

export function solve(input: string): number {
	throw Error
}
