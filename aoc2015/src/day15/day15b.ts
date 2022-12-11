import * as d15a from './day15a'

export function mapScore(ingredients: string[][], psv: number[]): number {
	let calories = ingredients
		.map(ing => ing[5])
		.map(c => parseInt(c))
		.map((c, ingI) => c * psv[ingI])
		.reduce((a, b) => a + b, 0)
	if (calories !== 500) {
		return 0
	}
	return d15a.mapScore(ingredients, psv)
}
