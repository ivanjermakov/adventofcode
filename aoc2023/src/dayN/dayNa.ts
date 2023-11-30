import { readFileSync } from 'fs'
import { todo } from '../util'

export function readInput(): string {
    return readFileSync('data/dayN.txt').toString().trim()
}

export function solve(input: string): number {
    return todo()
}
