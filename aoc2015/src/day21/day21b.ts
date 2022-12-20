import {equipmentCost, equipmentStats, PlayerEquipment, PlayerStats, purchaseCombinations, simulate} from './day21a'
import {sortBy} from 'lodash'

export function solve(enemyStats: PlayerStats): number {
	const combs: [PlayerEquipment, number][] = sortBy(purchaseCombinations().map(eq => [eq, equipmentCost(eq)]), eq => eq[1])
	const cs = combs.reverse()
	for (const [eq, c] of cs) {
		if (!simulate(equipmentStats(eq), enemyStats)) {
			return c
		}
	}
	throw Error
}
