export function solve(input: string): number {
	let current = 0
	for (const [i, c] of input.split('').entries()) {
		const d = c == '(' ? 1 : c == ')' ? -1 : NaN
		current += d
		if (current < 0) return i + 1
	}
	return NaN
}
