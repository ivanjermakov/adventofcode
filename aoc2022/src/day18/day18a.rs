use std::collections::HashSet;
use std::fs::read_to_string;

#[derive(Debug, PartialEq, Ord, PartialOrd, Eq, Clone, Copy, Hash)]
pub struct Vec3 {
    pub x: i32,
    pub y: i32,
    pub z: i32,
}

pub fn read_input_example() -> String {
    read_to_string("data/day18/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day18/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String) -> i32 {
    let coords = &parse_coords(input);
    let mut total: i32 = 0;
    for c in coords {
        let sides = get_sides();
        let free = sides
            .iter()
            .map(|s| {
                let t = Vec3 {
                    x: c.x + s.x,
                    y: c.y + s.y,
                    z: c.z + s.z,
                };
                coords.contains(&t)
            })
            .filter(|b| !*b)
            .count();
        total += free as i32;
    }
    total
}

pub fn get_sides() -> Vec<Vec3> {
    vec![
        Vec3 { x: 1, y: 0, z: 0 },
        Vec3 { x: -1, y: 0, z: 0 },
        Vec3 { x: 0, y: 1, z: 0 },
        Vec3 { x: 0, y: -1, z: 0 },
        Vec3 { x: 0, y: 0, z: 1 },
        Vec3 { x: 0, y: 0, z: -1 },
    ]
}

pub fn parse_coords(input: String) -> HashSet<Vec3> {
    input
        .split("\n")
        .map(|line| {
            let tokens = line
                .split(",")
                .map(|t| t.parse::<i32>().unwrap())
                .collect::<Vec<_>>();
            Vec3 {
                x: tokens[0],
                y: tokens[1],
                z: tokens[2],
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 64);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 4444);
    }
}
