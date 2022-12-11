import {range} from 'lodash'

export const alphabet = 'abcdefghijklmnopqrstuvwxyz'

export function readInput(): string {
	return 'cqjxjnds'
}

export function solve(input: string): string {
	let v = parseBase(input, 26)

	const hasPairs = (v26: string) => {
		const pairs = new Set()
		for (let i = 0; i < v26.length - 1; i++) {
			if (v26[i] == v26[i + 1]) {
				pairs.add(v26[i])
				i++
			}
		}
		return pairs.size > 1
	}

	while (true) {
		v++
		const v26 = toBase(v, 26)
		const a = !!v26.match(
			range(24)
				.flatMap(g => [0, 1, 2]
					.map(i => toBase(i + g, 26))
					.join(''))
				.map(r => `(${r})`).join('|')
		)
		const b = !v26.match(/[iol]/)
		const c = hasPairs(v26)
		if (a && b && c) {
			return v26
		}
	}
}

export function toBase(n: number, base: number): string {
	const extractPower = (n: number, p: number): number => {
		return Math.floor(n / Math.pow(base, p)) % base
	}
	const size = (n: number, base: number): number => {
		let s = 1
		while (n >= Math.pow(base, s)) {
			s++
		}
		return s
	}
	let converted = ''
	for (let i = size(n, base) - 1; i >= 0; i--) {
		converted += alphabet[extractPower(n, i)]
	}
	return converted
}

export function parseBase(n: string, base: number): number {
	let res = 0
	for (let i = 0; i < n.length; i++) {
		res += Math.pow(base, n.length - i - 1) * alphabet.indexOf(n[i])
	}
	return res
}
