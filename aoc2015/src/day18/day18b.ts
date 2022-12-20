import {parseGrid, step} from './day18a'

export function solve(input: string): number {
	let grid = parseGrid(input)
	turnOnCorners(grid)
	for (let i = 0; i < 100; i++) {
		grid = step(grid)
		turnOnCorners(grid)
	}
	return grid.flatMap(row => row.map((e): number => e ? 1 : 0)).reduce((a, b) => a + b, 0)
}

export function turnOnCorners(grid: boolean[][]): void {
	grid[0][0] = true
	grid[grid.length - 1][0] = true
	grid[0][grid[0].length - 1] = true
	grid[grid.length - 1][grid[0].length - 1] = true
}
