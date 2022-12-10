export function solve(input: string): number {
	const displaySize = input.split('\n').map(s => s.length).reduce((a, b) => a + b, 0)
	const encoded = input.split('\n')
		.map(line => {
			return '"' + line.split('').map(c => {
				if (['\\', '"'].includes(c)) {
					return '\\' + c
				} else {
					return c
				}
			}).join('') + '"'
		})
		.map(s => s.length).reduce((a, b) => a + b, 0)
	console.log(displaySize, encoded)
	return encoded - displaySize
}
