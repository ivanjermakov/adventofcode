import {powerSet} from '../day17/day17a'
import {clone, sortBy} from 'lodash'

export type ItemStats = [number, number, number]
export type PlayerStats = [number, number, number]

export interface Shop {
	weapons: ItemStats[];
	armor: ItemStats[];
	rings: ItemStats[]
}

export interface PlayerEquipment {
	weapon: ItemStats,
	armor: ItemStats | undefined,
	rings: ItemStats[]
}

export const shop: Shop = {
	weapons: [
		[8, 4, 0],
		[10, 5, 0],
		[25, 6, 0],
		[40, 7, 0],
		[74, 8, 0],
	],
	armor: [
		[13, 0, 1],
		[31, 0, 2],
		[53, 0, 3],
		[75, 0, 4],
		[102, 0, 5],
	],
	rings: [
		[25, 1, 0],
		[50, 2, 0],
		[100, 3, 0],
		[20, 0, 1],
		[40, 0, 2],
		[80, 0, 3],
	]
}

export function solve(enemyStats: PlayerStats): number {
	const combs: [PlayerEquipment, number][] = sortBy(purchaseCombinations().map(eq => [eq, equipmentCost(eq)]), eq => eq[1])
	for (const [eq, c] of combs) {
		if (simulate(equipmentStats(eq), enemyStats)) {
			return c
		}
	}
	throw Error
}

export function equipmentCost(eq: PlayerEquipment): number {
	return eq.weapon[0] + (eq.armor?.[0] || 0) + eq.rings.map(r => r[0]).reduce((a, b) => a + b, 0)
}

export function equipmentStats(eq: PlayerEquipment): PlayerStats {
	const stats: PlayerStats = [100, 0, 0]
	stats[1] += eq.weapon[1]
	stats[2] += eq.armor?.[2] || 0
	let ringStats = eq.rings.reduce(([d, a], r) => [d + r[1], a + r[2]], [0, 0])
	stats[1] += ringStats[0]
	stats[2] += ringStats[1]
	return stats
}

export function purchaseCombinations(): PlayerEquipment[] {
	const weaponArmorCombs: PlayerEquipment[] = shop
		.weapons
		.flatMap(w => shop.armor
			.flatMap(a => [[w, undefined], [w, a]])
		)
		.flatMap(([w, a]): PlayerEquipment => ({
			weapon: w!,
			armor: a,
			rings: []
		}))
	const ringCombs = powerSet(shop.rings).filter(s => s.length <= 2)
	return cartesianProduct(weaponArmorCombs, ringCombs).map(([eq, rings]) => {
		eq.rings = rings
		return eq
	})
}

export function simulate(playerStats: PlayerStats, enemyStats: PlayerStats): boolean {
	const enemySts = clone(enemyStats)
	const playerSts = clone(playerStats)
	while (true) {
		enemySts[0] = enemySts[0] - damageDealt(playerStats[1], enemyStats[2])
		if (enemySts[0] <= 0) {
			return true
		}
		playerSts[0] = playerSts[0] - damageDealt(enemyStats[1], playerStats[2])
		if (playerSts[0] <= 0) {
			return false
		}
	}
}

export function damageDealt(attack: number, armor: number): number {
	return Math.max(attack - armor, 1)
}

export function cartesianProduct<T, V>(a1: T[], a2: V[]): [T, V][] {
	return a1.flatMap(a => a2.map((b): [T, V] => [clone(a), clone(b)]))
}
