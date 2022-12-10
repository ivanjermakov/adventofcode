import {readFileSync} from 'fs'

export function readInput(): string {
	return readFileSync('data/day6.txt').toString().trim()
}

export function solve(input: string): number {
	const grid: boolean[][] = []
	for (let y = 0; y < 1000; y++) {
		grid[y] = []
		for (let x = 0; x < 1000; x++) {
			grid[y][x] = false
		}
	}
	input.split('\n').map(line => {
		const [command, f, t] = line.split(' ')
		const [fx, fy] = f.split(',').map(t => Number(t))
		const [tx, ty] = t.split(',').map(t => Number(t))
		for (let ny = fy; ny <= ty; ny++) {
			for (let nx = fx; nx <= tx; nx++) {
				switch (command) {
					case 'on':
						grid[ny][nx] = true
						break
					case 'off':
						grid[ny][nx] = false
						break
					case 'toggle':
						grid[ny][nx] = !grid[ny][nx]
						break
				}

			}
		}
	})
	return grid.flatMap(e => e).filter(b => !!b).length
}
