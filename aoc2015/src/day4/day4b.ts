import {md5} from './md5'

export function solve(input: string): number {
	for (let i = 0; ; i++) {
		const hash = md5(input + i.toString())
		if (hash.startsWith('000000')) {
			return i
		}
	}
}
