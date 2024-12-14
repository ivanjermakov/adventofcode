import os
import sequtils
import strutils

type Vec2 = object
    x: int
    y: int

type Robot = object
    pos: Vec2
    vel: Vec2

const gridSize = Vec2(x: 101, y: 103)

func euclideanMod(a: int, b: int): int = ((a.mod(b)) + b).mod(b)

func move(robot: Robot, moves: int): Robot =
    let nx = robot.pos.x + robot.vel.x * moves
    let ny = robot.pos.y + robot.vel.y * moves
    Robot(
        pos: Vec2(
            x: euclideanMod(nx, gridSize.x),
            y: euclideanMod(ny, gridSize.y)
        ),
        vel: robot.vel
    )

let input = readFile("data/day14.txt")
var robots = input
    .splitLines()
    .filter(func(l: string): bool = l.len() > 0)
    .map(func(l: string): Robot =
        let ts = l.split(' ')
        let p = ts[0][2..^1].split(',').map(parseInt)
        let v = ts[1][2..^1].split(',').map(parseInt)
        Robot(pos: Vec2(x: p[0], y: p[1]), vel: Vec2(x: v[0], y: v[1]))
    )
    .map(func(r: Robot): Robot = move(r, 100))

var q1 = 0
var q2 = 0
var q3 = 0
var q4 = 0

let sep = Vec2(x: gridSize.x div 2, y: gridSize.y div 2)
for r in robots:
    if r.pos.x < sep.x and r.pos.y < sep.y:
        q1 += 1
    if r.pos.x > sep.x and r.pos.y < sep.y:
        q2 += 1
    if r.pos.x < sep.x and r.pos.y > sep.y:
        q3 += 1
    if r.pos.x > sep.x and r.pos.y > sep.y:
        q4 += 1

echo(q1 * q2 * q3 * q4)
