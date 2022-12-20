import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/day18.txt').toString().trim()
}

export function solve(input: string): number {
	let grid = parseGrid(input)
	for (let i = 0; i < 100; i++) {
		grid = step(grid)
	}
	return grid.flatMap(row => row.map((e): number => e ? 1 : 0)).reduce((a, b) => a + b, 0)
}

export function step(grid: boolean[][]): boolean[][] {
	return grid.map((row, y) => row.map((e, x) => {
		let ns = neighborsCount(grid, [y, x])
		if (e) {
			return ns === 2 || ns === 3
		} else {
			return ns === 3
		}
	}))
}

export function neighborsCount(grid: boolean[][], [py, px]: [number, number]): number {
	return [
		[-1, -1], [-1, 0], [-1, 1],
		[0, -1], [0, 1],
		[1, -1], [1, 0], [1, 1]
	]
		.map(([dy, dx]): number => {
			let [y, x] = [dy + py, dx + px]
			if (x < 0 || x >= grid[0].length || y < 0 || y >= grid.length) {
				return 0
			}
			return grid[y][x] ? 1 : 0
		})
		.reduce((a, b) => a + b, 0)
}

export function parseGrid(input: string): boolean[][] {
	return input.split('\n').map(l => l.split('').map(c => c == '#'))
}
