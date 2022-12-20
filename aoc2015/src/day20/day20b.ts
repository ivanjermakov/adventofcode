import {divisors} from './day20a'

export function solve(score: number): number {
	for (let i = 1; ; i++) {
		if (houseScore(i) >= score) {
			return i
		}
	}
}

export function houseScore(n: number): number {
	return divisors(n).filter(d => n / d <= 50).map(d => d * 11).reduce((a, b) => a + b, 0)
}
