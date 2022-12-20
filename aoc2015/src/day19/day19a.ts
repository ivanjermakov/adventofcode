import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/day19.txt').toString().trim()
}

export function solve(input: string): number {
	const [rs, m] = parseInput(input)
	const ways = new Set<string>()
	for (let [t, r] of rs) {
		const ms = [...m.matchAll(new RegExp(t, 'g'))].map(m => m.index!)
		for (let matchIdx of ms) {
			const newS = replaceAt(m, matchIdx, t.length, r)
			ways.add(newS)
		}
	}
	return ways.size
}

export function parseInput(input: string): [[string, string][], string] {
	const [rgs, mg] = input.split('\n\n')
	let rs = rgs.split('\n').map((rg): [string, string] => {
		const [t, r] = rg.split(' => ')
		return [t, r]
	})
	return [rs, mg]
}

export function replaceAt(base: string, index: number, drop: number, replacement: string): string {
	return base.substring(0, index) + replacement + base.substring(index + drop)
}
