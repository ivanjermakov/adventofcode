import {readFileSync} from 'fs'

export class Sue {
	id: number
	things: Map<string, number>

	constructor(id: number, things: Map<string, number>) {
		this.id = id
		this.things = things
	}

	match(search: Map<string, number>): boolean {
		return [...this.things.entries()].every(([k, v]) => search.get(k)! == v)
	}

	matchNew(search: Map<string, number>): boolean {
		return [...this.things.entries()].every(([k, v]) => {
			switch (k) {
				case 'cats':
				case 'trees':
					return search.get(k)! < v
				case 'pomeranians':
				case 'goldfish':
					return search.get(k)! > v
				default:
					return search.get(k)! == v
			}
		})
	}
}

export function readInput(): string {
	return readFileSync('data/day16.txt').toString().trim()
}

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
	let found = sues.filter(s => s.match(search))
	return found[0].id
}

export function parseSues(input: string): Sue[] {
	return input.split('\n').map(line => {
		let [id, things] = line.split(' = ')
		return new Sue(
			parseInt(id),
			new Map<string, number>(Object.entries(JSON.parse('{' + things + '}')))
		)
	})
}
