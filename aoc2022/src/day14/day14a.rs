use std::collections::HashSet;
use std::fs::read_to_string;

use crate::day9::day9a::Vec2;

pub fn read_input_example() -> String {
    read_to_string("data/day14/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day14/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String) -> i32 {
    let walls = parse_walls(input);
    let mut sand: HashSet<Vec2> = HashSet::new();
    let start = Vec2 { x: 500, y: 0 };
    loop {
        let next_sand_pos = place_sand(&start, &walls, &sand, 0);
        if let Some(p) = next_sand_pos {
            sand.insert(p);
        } else {
            return sand.len() as i32;
        }
    }
}

pub fn parse_walls(input: String) -> HashSet<Vec2> {
    input
        .split("\n")
        .map(|line| {
            line.split(" -> ")
                .map(|poss| {
                    let tokens = poss
                        .split(",")
                        .map(|t| t.parse::<i32>().unwrap())
                        .collect::<Vec<i32>>();
                    Vec2 {
                        x: tokens[0],
                        y: tokens[1],
                    }
                })
                .collect::<Vec<Vec2>>()
        })
        .flat_map(|wps| {
            let mut points: Vec<Vec2> = vec![];
            for i in 0..wps.len() - 1 {
                let a = wps[i];
                let b = wps[i + 1];
                points.extend(wall_cells(a, b))
            }
            points
        })
        .collect::<HashSet<Vec2>>()
}

pub fn place_sand(
    pos: &Vec2,
    walls: &HashSet<Vec2>,
    sand: &HashSet<Vec2>,
    step: i32,
) -> Option<Vec2> {
    if step > 1000 {
        return None;
    }

    let down = Vec2 {
        x: pos.x,
        y: pos.y + 1,
    };
    if !walls.contains(&down) && !sand.contains(&down) {
        return place_sand(&down, walls, sand, step + 1);
    }

    let bottom_left = Vec2 {
        x: pos.x - 1,
        y: pos.y + 1,
    };
    if !walls.contains(&bottom_left) && !sand.contains(&bottom_left) {
        return place_sand(&bottom_left, walls, sand, step + 1);
    }

    let bottom_right = Vec2 {
        x: pos.x + 1,
        y: pos.y + 1,
    };
    if !walls.contains(&bottom_right) && !sand.contains(&bottom_right) {
        return place_sand(&bottom_right, walls, sand, step + 1);
    }

    return Some(pos.clone());
}

fn wall_cells(a: Vec2, b: Vec2) -> Vec<Vec2> {
    if a.x == b.x {
        return if a.y < b.y {
            (a.y..b.y + 1).map(|y| Vec2 { x: a.x, y }).collect()
        } else {
            (b.y..a.y + 1).map(|y| Vec2 { x: a.x, y }).collect()
        };
    }
    if a.y == b.y {
        return if a.x < b.x {
            (a.x..b.x + 1).map(|x| Vec2 { x, y: a.y }).collect()
        } else {
            (b.x..a.x + 1).map(|x| Vec2 { x, y: a.y }).collect()
        };
    }
    unreachable!()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 24);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 768);
    }
}
