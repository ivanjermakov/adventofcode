use std::collections::HashSet;

use crate::day14::day14a::parse_walls;
use crate::day9::day9a::Vec2;

pub fn solve(input: String) -> i32 {
    let walls = parse_walls(input);
    let mut sand: HashSet<Vec2> = HashSet::new();
    let start = Vec2 { x: 500, y: 0 };

    let mut ys = walls.iter().map(|w| w.y).collect::<Vec<i32>>();
    ys.sort();
    ys.reverse();
    let max_y: i32 = ys[0];

    loop {
        let next_sand_pos = place_sand(&start, &walls, &sand, max_y, 0);
        sand.insert(next_sand_pos);
        if next_sand_pos == start {
            return sand.len() as i32;
        }
    }
}

pub fn place_sand(
    pos: &Vec2,
    walls: &HashSet<Vec2>,
    sand: &HashSet<Vec2>,
    max_y: i32,
    step: i32,
) -> Vec2 {
    if step > 1000 {
        panic!("depth limit reached");
    }
    if pos.y == max_y + 1 {
        return pos.clone();
    }

    let down = Vec2 {
        x: pos.x,
        y: pos.y + 1,
    };
    if !walls.contains(&down) && !sand.contains(&down) {
        return place_sand(&down, walls, sand, max_y, step + 1);
    }

    let bottom_left = Vec2 {
        x: pos.x - 1,
        y: pos.y + 1,
    };
    if !walls.contains(&bottom_left) && !sand.contains(&bottom_left) {
        return place_sand(&bottom_left, walls, sand, max_y, step + 1);
    }

    let bottom_right = Vec2 {
        x: pos.x + 1,
        y: pos.y + 1,
    };
    if !walls.contains(&bottom_right) && !sand.contains(&bottom_right) {
        return place_sand(&bottom_right, walls, sand, max_y, step + 1);
    }

    return pos.clone();
}

#[cfg(test)]
mod tests {
    use crate::day14::day14a::{read_input, read_input_example};

    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 93);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 26686);
    }
}
