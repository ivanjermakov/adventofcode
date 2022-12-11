export const solve = (input: string): number => count(JSON.parse(input))

function count(obj: any): number {
	if (typeof obj === 'string') {
		return 0
	}
	if (typeof obj === 'number') {
		return obj
	}
	if (obj instanceof Array) {
		return obj.map(e => count(e)).reduce((a, b) => a + b, 0)
	}
	if (obj instanceof Object) {
		if (Object.values(obj).some(k => k === 'red')) {
			return 0
		}
		return Object.values(obj).map(e => count(e)).reduce((a, b) => a + b, 0)
	}
	throw Error(`unknown type ${obj}`)
}
