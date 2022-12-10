export function solve(input: string): number {
	return input.split('\n').filter(line => {
		const a = !!line.match(/(.{2}).*(\1)/)
		const b = !!line.match(/(.).{1}(\1)/)
		return a && b
	}).length
}
