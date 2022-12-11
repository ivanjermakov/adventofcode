import {readFileSync} from 'fs'
import {orderBy} from 'lodash'

export function readInput(): string {
	return readFileSync('data/day14.txt').toString().trim()
}

export function solve(input: string, t: number): number {
	const deerList = input.split('\n').map(l => l.split(' ').map(t => parseInt(t)))
	const dists = deerList.map(d => distAfter(d, t))
	return orderBy(dists).reverse()[0]
}

export function distAfter([speed, runTime, restTime]: number[], t: number): number {
	let cycleTime = runTime + restTime
	const fullCycles = Math.floor(t / cycleTime)
	const partTime = t - fullCycles * cycleTime
	const cycleDist = runTime * speed
	const partDist = Math.min(partTime, runTime) * speed
	return fullCycles * cycleDist + partDist
}
