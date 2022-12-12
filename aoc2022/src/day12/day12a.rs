use std::collections::{HashMap, VecDeque};
use std::fs::read_to_string;

use crate::day9::day9a::Vec2;

#[derive(Debug, PartialOrd, PartialEq)]
pub struct Grid {
    pub grid: Vec<Vec<i32>>,
    pub start_pos: Vec2,
    pub target_pos: Vec2,
}

pub const ALPHABET: &str = "abcdefghijklmnopqrstuvwxyz";

pub fn read_input_example() -> String {
    read_to_string("data/day12/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day12/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String) -> i32 {
    let grid = parse_grid(input);
    let path = bfs(&grid);
    path.len() as i32 - 1
}

pub fn bfs(grid: &Grid) -> Vec<Vec2> {
    let mut parent_map = HashMap::<Vec2, Vec2>::new();
    let mut queue = VecDeque::<Vec2>::new();
    let mut explored = vec![grid.start_pos];
    queue.push_back(grid.start_pos);

    while !queue.is_empty() {
        let pos = queue.pop_front().unwrap();
        if pos == grid.target_pos {
            let mut path = vec![pos];
            let mut node = pos;
            loop {
                let parent = parent_map.get(&node).unwrap();
                path.push(*parent);
                if parent == &grid.start_pos {
                    path.reverse();
                    return path;
                }
                node = *parent;
            }
        }
        for d in vec![
            Vec2 { x: 0, y: -1 },
            Vec2 { x: 1, y: 0 },
            Vec2 { x: 0, y: 1 },
            Vec2 { x: -1, y: 0 },
        ] {
            let n_pos = Vec2 {
                x: pos.x + d.x,
                y: pos.y + d.y,
            };
            if !explored.contains(&n_pos) && can_go(pos, n_pos, &grid) {
                explored.push(n_pos);
                parent_map.insert(n_pos, pos);
                queue.push_back(n_pos);
            }
        }
    }
    unreachable!()
}

pub fn can_go(from_pos: Vec2, to_pos: Vec2, grid: &Grid) -> bool {
    if to_pos.y >= 0
        && to_pos.y < grid.grid.len() as i32
        && to_pos.x >= 0
        && to_pos.x < grid.grid[0].len() as i32
    {
        let from_v = grid.grid[from_pos.y as usize][from_pos.x as usize];
        let to_v = grid.grid[to_pos.y as usize][to_pos.x as usize];
        if to_v - from_v <= 1 {
            return true;
        }
    }
    return false;
}

pub fn parse_grid(input: String) -> Grid {
    let mut current_pos = Vec2 { x: 0, y: 0 };
    let mut target_pos = Vec2 { x: 0, y: 0 };
    let mut grid: Vec<Vec<i32>> = vec![];
    for y in 0..input.split("\n").collect::<Vec<&str>>().len() {
        grid.push(vec![]);
        let line = input.split("\n").collect::<Vec<&str>>()[y];
        for x in 0..line.len() {
            let c = line.chars().collect::<Vec<char>>()[x];
            let v = Vec2 {
                x: x as i32,
                y: y as i32,
            };
            let v = match c {
                'S' => {
                    current_pos = v;
                    0
                }
                'E' => {
                    target_pos = v;
                    25
                }
                _ => ALPHABET
                    .chars()
                    .position(|x| x == c.to_ascii_lowercase())
                    .unwrap(),
            };
            grid[y].push(v as i32)
        }
    }
    Grid {
        grid,
        start_pos: current_pos,
        target_pos,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 31);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 528);
    }
}
