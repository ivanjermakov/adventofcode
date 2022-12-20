export function solve(score: number): number {
	for (let i = 1; ; i++) {
		if (houseScore(i) >= score) {
			return i
		}
	}
}

export function houseScore(n: number): number {
	return divisors(n).map(d => d * 10).reduce((a, b) => a + b, 0)
}

export function divisors(n: number): number[] {
	const ns = []
	for (let i = 1; i <= Math.sqrt(n); i++) {
		if (n % i == 0) {
			ns.push(i)
			const nu = Math.floor(n / i)
			if (nu != i) {
				ns.push(nu)
			}
		}
	}
	return ns
}
