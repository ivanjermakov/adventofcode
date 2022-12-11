export function readInput(): string {
	return '1113122113'
}

export function solve(input: string, repetitions: number): string {
	let res = input
	for (let i = 0; i < repetitions; i++) {
		res = transform(res)
	}
	return res
}

export function transform(input: string): string {
	const groups: string[][] = []
	input.split('').forEach((c) => {
		let lastGroup = groups[groups.length - 1]
		if (lastGroup && lastGroup[0] === c) {
			lastGroup.push(c)
		} else {
			groups.push([c])
			return
		}
	})
	return groups.map(l => l.length.toString() + l[0]).join('')
}
