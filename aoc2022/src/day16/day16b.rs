use std::collections::HashSet;

#[derive(Debug, PartialEq, Ord, PartialOrd, Eq, Clone, Copy, Hash)]
pub struct Vec2 {
    pub x: i128,
    pub y: i128,
}

pub fn solve(input: String, bounds: Vec2) -> i128 {
    let pairs = input
        .split("\n")
        .map(|l| parse_pair(l.to_string()))
        .collect::<HashSet<(Vec2, Vec2)>>();
    let beacon_pos = find_beacon(&pairs, bounds);
    beacon_pos.x as i128 * 4000000 + beacon_pos.y as i128
}

pub fn parse_pair(input: String) -> (Vec2, Vec2) {
    let ns = input
        .split(" ")
        .map(|tokens| tokens.parse::<i128>().unwrap())
        .collect::<Vec<i128>>();
    return (Vec2 { x: ns[0], y: ns[1] }, Vec2 { x: ns[2], y: ns[3] });
}

fn valid(pairs: &HashSet<(Vec2, Vec2)>, pos: Vec2) -> bool {
    let mut valid = true;
    for (s, b) in pairs {
        let r = get_dist(s, b);
        let d = get_dist(&pos, s);
        if d <= r {
            valid = false;
        }
    }
    valid
}

pub fn get_dist(p1: &Vec2, p2: &Vec2) -> i128 {
    return (p1.x - p2.x).abs() + (p1.y - p2.y).abs();
}

fn find_beacon(pairs: &HashSet<(Vec2, Vec2)>, bounds: Vec2) -> Vec2 {
    for (s, b) in pairs {
        let r = get_dist(s, b);
        for dx in 0..r + 2 {
            let dy = (r + 1) - dx;
            for (sign_x, sign_y) in [(-1, -1), (-1, 1), (1, -1), (1, 1)] {
                let pos = Vec2 {
                    x: s.x + dx * sign_x,
                    y: s.y + dy * sign_y,
                };
                if !(pos.x >= 0 && pos.x <= bounds.x && pos.y >= 0 && pos.y <= bounds.y) {
                    continue;
                }
                assert_eq!(get_dist(&pos, s), r + 1);
                if valid(pairs, pos) {
                    return pos;
                }
            }
        }
    }
    panic!("not found")
}

#[cfg(test)]
mod tests {
    use crate::day15::day15a::{read_input, read_input_example};

    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input, Vec2 { x: 20, y: 20 });
        assert_eq!(result, 56000011);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(
            input,
            Vec2 {
                x: 4000000,
                y: 4000000,
            },
        );
        assert_eq!(result, 12625383204261);
    }
}
