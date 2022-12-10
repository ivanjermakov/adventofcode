import {readFileSync} from 'fs'

export interface Expression {
	operands: string[]
	operator?: string
	value?: number
}

export function readInput(): string {
	return readFileSync('data/day7a.txt').toString().trim()
}

export function solve(input: string, r: string): number {
	const registerMap = new Map<string, Expression>()
	input.split('\n').map(line => {
		let tokens = line.split(' ')
		if (tokens.length == 3) {
			let v = Number(tokens[0])
			if (Number.isNaN(v)) {
				registerMap.set(tokens[2], {operands: [tokens[0]]})
			} else {
				registerMap.set(tokens[2], {operands: [], value: v})
			}
		}
		if (tokens.length == 4) {
			registerMap.set(tokens[3], {operands: [tokens[1]], operator: tokens[0]})
		}
		if (tokens.length == 5) {
			registerMap.set(tokens[4], {operands: [tokens[0], tokens[2]], operator: tokens[1]})
		}

	})
	return calculate(r, registerMap)
}

export function calculate(register: string, m: Map<string, Expression>, c = new Map<string, number>()): number {
	let cached = c.get(register)
	if (cached) {
		return cached
	}
	if (!Number.isNaN(parseInt(register))) {
		return parseInt(register)
	}
	const exp = m.get(register)!
	if (exp.value !== undefined) {
		return exp.value
	}

	if (!exp.operator) {
		let res = calculate(exp.operands[0], m, c)
		c.set(register, res)
		return res
	}

	let res
	switch (exp.operator) {
		case 'NOT':
			res = ~calculate(exp.operands[0], m, c) & 65535
			break
		case 'AND':
			res = calculate(exp.operands[0], m, c) & calculate(exp.operands[1], m, c)
			break
		case 'OR':
			res = calculate(exp.operands[0], m, c) | calculate(exp.operands[1], m, c)
			break
		case 'LSHIFT':
			res = calculate(exp.operands[0], m, c) << calculate(exp.operands[1], m, c) & 65535
			break
		case 'RSHIFT':
			res = calculate(exp.operands[0], m, c) >> calculate(exp.operands[1], m, c)
			break
		default:
			throw Error(`unknown operator ${exp.operator}`)
	}
	c.set(register, res)
	return res
}
