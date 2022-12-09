import {readFileSync} from 'fs'
import {md5} from './md5'

export function readInput(): string {
	return 'bgvyzdsv'
}

export function solve(input: string): number {
	for (let i = 0; ; i++) {
		const hash = md5(input + i.toString())
		if (hash.startsWith('00000')) {
			return i
		}
	}
}

