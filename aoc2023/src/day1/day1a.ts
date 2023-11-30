import { readFileSync } from 'fs'
import { todo } from '../util'

export function readInput(): string {
    return readFileSync('data/day1.txt').toString().trim()
}

export function solve(input: string): number {
    return todo()
}
