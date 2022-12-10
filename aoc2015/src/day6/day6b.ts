export function solve(input: string): number {
	const grid: number[][] = []
	for (let y = 0; y < 1000; y++) {
		grid[y] = []
		for (let x = 0; x < 1000; x++) {
			grid[y][x] = 0
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
						grid[ny][nx]++
						break
					case 'off':
						grid[ny][nx] = Math.max(grid[ny][nx] - 1, 0)
						break
					case 'toggle':
						grid[ny][nx] += 2
						break
				}

			}
		}
	})
	return grid.flatMap(e => e).reduce((a, b) => a + b, 0)
}
