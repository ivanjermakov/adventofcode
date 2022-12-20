import {powerSet} from './day17a'
import {min} from 'lodash'

export function solve(input: string, total: number): number {
	const ns = input.split('\n').map(l => parseInt(l))
	const res = powerSet(ns).filter(s => s.reduce((a, b) => a + b, 0) == total)
	const lowest = min(res.map(l => l.length))
	return res.filter(l => l.length === lowest).length
}
