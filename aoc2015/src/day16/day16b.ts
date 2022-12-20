import {parseSues} from './day16a'

export function solve(input: string): number {
	let sues = parseSues(input)
	let search = new Map<string, number>(Object.entries({
		children: 3,
		cats: 7,
		samoyeds: 2,
		pomeranians: 3,
		akitas: 0,
		vizslas: 0,
		goldfish: 5,
		trees: 3,
		cars: 2,
		perfumes: 1
	}))
	let found = sues.filter(s => s.matchNew(search))
	return found[0].id
}
