import {readFileSync} from 'fs'
import {range, sortBy, zip} from 'lodash'
import {permute} from '../day9/day9a'

export function readInput(): string {
	return readFileSync('data/day15.txt').toString().trim()
}

export function solve(input: string, scoreFn: (ingredients: string[][], psv: number[]) => number): number {
	const ingredients = input.split('\n').map(l => l.split(' '))
	const ss = ingredients.length === 4 ? subsetSum4(100) : subsetSum2(100)
	const variants = ss.flatMap(ps => permute(ps).map(psv => scoreFn(ingredients, psv)))
	return sortBy(variants).reverse()[0]
}

export function mapScore(ingredients: string[][], psv: number[]): number {
	return range(1, 5)
		.map(typeI => zip(ingredients.map(ing => ing[typeI]), psv)
			.map(([type, weight]) => parseInt(type!) * weight!)
			.reduce((a, b) => a + b, 0)
		)
		.map(s => Math.max(s, 0))
		.reduce((a, b) => a * b, 1)
}

export function subsetSum4(total: number): number[][] {
	const ss = []
	for (let a = 0; a <= total; a++) {
		for (let b = a; b <= total - a; b++) {
			for (let c = b; c <= total - a - b; c++) {
				for (let d = c; d <= total - a - b - c; d++) {
					if (a + b + c + d === total) {
						ss.push([a, b, c, d])
					}
				}
			}
		}
	}
	return ss
}

export function subsetSum2(total: number): number[][] {
	const ss = []
	for (let a = 0; a <= total; a++) {
		for (let b = a; b <= total - a; b++) {
			if (a + b === total) {
				ss.push([a, b])
			}
		}
	}
	return ss
}
