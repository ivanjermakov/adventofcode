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

proc filterPattern(robots: seq[Robot]): bool =
    for i in 0..gridSize.y:
        var start = -1
        for j in 0..gridSize.x:
            if any(robots, proc(r: Robot): bool = r.pos.x == j and r.pos.y == i):
                if start == -1:
                    start = j
            else:
                if start != -1 and j - start > 30:
                    return true
                start = -1
    return false

proc gridToString(robots: seq[Robot]): string =
    var res: string = ""
    for i in 0..gridSize.x:
        for j in 0..gridSize.y:
            if any(robots, proc(r: Robot): bool = r.pos.x == i and r.pos.y == j):
                res &= '#'
            else:
                res &= ' '
        res &= '\n'
    return res

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

for i in 0..100000:
    robots = robots.map(func(r: Robot): Robot = move(r, 1))
    if filterPattern(robots):
        let str = gridToString(robots)
        echo(i)
        echo(str)
        break
