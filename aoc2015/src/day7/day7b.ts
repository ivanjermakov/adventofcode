import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/day7b.txt').toString().trim()
}
