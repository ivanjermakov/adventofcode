use crate::day9::day9a::Vec2;
use std::collections::HashSet;
use std::fs::read_to_string;

pub fn read_input_example() -> String {
    read_to_string("data/day15/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day15/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String, y: i32) -> i32 {
    let pairs = input
        .split("\n")
        .map(|l| parse_pair(l.to_string()))
        .collect::<HashSet<(Vec2, Vec2)>>();
    let mut xs = pairs
        .iter()
        .flat_map(|(s, b)| vec![s.clone(), b.clone()])
        .map(|v| v.x)
        .collect::<Vec<i32>>();
    xs.sort();
    xs.reverse();
    let max_x = xs[0];
    let covered_poss = get_covered(&pairs, y, max_x);
    covered_poss.len() as i32
}

fn get_covered(pairs: &HashSet<(Vec2, Vec2)>, y: i32, max_x: i32) -> HashSet<Vec2> {
    let mut covered = HashSet::new();
    for x in -1000000..max_x + 1000000 {
        let pos = Vec2 { x, y };
        if pairs.into_iter().any(|(s, b)| s == &pos || b == &pos) {
            continue;
        }
        for pair in pairs.into_iter() {
            let d = get_dist(&pair.0, &pair.1);
            if get_dist(&pos, &pair.0) <= d {
                covered.insert(pos);
            }
        }
    }
    covered
}

pub fn get_dist(p1: &Vec2, p2: &Vec2) -> i32 {
    return (p1.x - p2.x).abs() + (p1.y - p2.y).abs();
}

pub fn parse_pair(input: String) -> (Vec2, Vec2) {
    let ns = input
        .split(" ")
        .map(|tokens| tokens.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();
    return (Vec2 { x: ns[0], y: ns[1] }, Vec2 { x: ns[2], y: ns[3] });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input, 10);
        assert_eq!(result, 26);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input, 2000000);
        assert_eq!(result, 5688618);
    }
}
