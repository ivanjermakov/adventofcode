use std::collections::{HashMap, VecDeque};

use crate::day12::day12a::{parse_grid, Grid};
use crate::day9::day9a::Vec2;

pub fn solve(input: String) -> i32 {
    let grid = parse_grid(input);
    let path = bfs(&grid);
    path.expect("no path found").len() as i32 - 1
}

pub fn bfs(grid: &Grid) -> Option<Vec<Vec2>> {
    let mut parent_map = HashMap::<Vec2, Vec2>::new();
    let mut queue = VecDeque::<Vec2>::new();
    let mut explored = vec![grid.target_pos];
    queue.push_back(grid.target_pos);

    while !queue.is_empty() {
        let pos = queue.pop_front().unwrap();
        if grid.grid[pos.y as usize][pos.x as usize] == 0 {
            let mut path = vec![pos];
            let mut node = pos;
            loop {
                let parent = parent_map.get(&node).unwrap();
                path.push(*parent);
                if parent == &grid.target_pos {
                    return Some(path);
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
    None
}

pub fn can_go(from_pos: Vec2, to_pos: Vec2, grid: &Grid) -> bool {
    if to_pos.y >= 0
        && to_pos.y < grid.grid.len() as i32
        && to_pos.x >= 0
        && to_pos.x < grid.grid[0].len() as i32
    {
        let from_v = grid.grid[from_pos.y as usize][from_pos.x as usize];
        let to_v = grid.grid[to_pos.y as usize][to_pos.x as usize];
        if from_v - to_v <= 1 {
            return true;
        }
    }
    return false;
}

#[cfg(test)]
mod tests {
    use crate::day12::day12a::{read_input, read_input_example};

    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 29);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 522);
    }
}
