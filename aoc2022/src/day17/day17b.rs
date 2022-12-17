use crate::day17::day17a::{format_tower, highest_occupied_y, is_legal, shapes, Shape};
use crate::day9::day9a::Vec2;
use std::collections::HashSet;

#[derive(Debug)]
pub struct Cycle {
    pub piece_count: usize,
    pub stream_offset: usize,
    pub piece_offset: usize,
    pub height: i128,
}

pub fn solve(input: String) -> i128 {
    let cycle = find_cycle(input.clone()).unwrap();
    println!("cycle: {:?}", cycle);
    let target_pieces = 1000000000000;
    let complete_cycles = target_pieces / cycle.piece_count;
    let left_pieces = target_pieces % cycle.piece_count;

    let before_cycle_h = sim_height(&input, 0, cycle.piece_offset, 0);
    let after_cycle_h = sim_height(&input, cycle.piece_offset, left_pieces, cycle.stream_offset);

    let shapes: Vec<Shape> = shapes();
    let mut grid = HashSet::new();
    let mut off = cycle.stream_offset;
    for p in cycle.piece_offset..left_pieces + cycle.piece_offset {
        let (g, o) = drop(&grid, &shapes[p % shapes.len()], &input, off);
        grid.extend(g);
        off = o;
    }
    println!("complete: {}", complete_cycles * cycle.piece_count);
    before_cycle_h + ((complete_cycles) as i128 * cycle.height as i128) + after_cycle_h
}

pub fn sim_height(input: &String, skip: usize, take: usize, stream_offset: usize) -> i128 {
    let shapes: Vec<Shape> = shapes();
    let mut grid = HashSet::new();
    let mut off = stream_offset;
    println!("pieces: {}", (skip..take).len());
    for p in skip..take {
        let (g, o) = drop(&grid, &shapes[p % shapes.len()], &input, off);
        grid.extend(g);
        off = o;
    }
    -highest_occupied_y(&grid) as i128 + 1
}

pub fn find_cycle(input: String) -> Option<Cycle> {
    let shapes: Vec<Shape> = shapes();
    let mut grid = HashSet::new();
    let mut off = 0;
    let mut states: HashSet<(usize, usize, Vec<Vec2>)> = HashSet::new();
    for p in 1000..10000 {
        let (g, o) = drop(&grid, &shapes[p % shapes.len()], &input, off);
        grid.extend(g);
        off = o;
        let h = highest_occupied_y(&grid);
        let state = (
            off % input.len(),
            p % shapes.len(),
            grid.iter()
                .cloned()
                .map(|p| Vec2 { x: p.x, y: h - p.y })
                .filter(|p| p.y > 10)
                .collect::<Vec<_>>(),
        );
        if states.contains(&state) {
            let h = -highest_occupied_y(&grid) + 1;
            return Some(Cycle {
                piece_count: p - 1000,
                stream_offset: state.0,
                piece_offset: state.1,
                height: h as i128,
            });
        } else {
            states.insert(state);
        }
    }
    None
}

pub fn drop(
    occupied: &HashSet<Vec2>,
    shape: &Shape,
    path: &String,
    move_offset: usize,
) -> (HashSet<Vec2>, usize) {
    let mut off = move_offset;
    let max_y = highest_occupied_y(occupied);
    let mut delta = Vec2 { x: 2, y: max_y - 4 };
    loop {
        let c = path.chars().nth(off % path.len()).unwrap();
        match c {
            '>' => {
                if is_legal(shape, &delta.add(&Vec2 { x: 1, y: 0 }), occupied) {
                    delta.x += 1;
                }
            }
            '<' => {
                if is_legal(shape, &delta.add(&Vec2 { x: -1, y: 0 }), occupied) {
                    delta.x -= 1;
                }
            }
            _ => unreachable!(),
        }
        off += 1;

        if is_legal(shape, &delta.add(&Vec2 { x: 0, y: 1 }), occupied) {
            delta.y += 1;
        } else {
            break;
        }
    }

    return (
        shape
            .iter()
            .map(|p| Vec2 {
                x: p.x + delta.x,
                y: p.y + delta.y,
            })
            .collect(),
        off,
    );
}

#[cfg(test)]
mod tests {
    use crate::day17::day17a::{read_input, read_input_example};

    use super::*;

    #[test]
    #[ignore]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 1514285714288);
    }

    #[test]
    #[ignore]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 1594842406882);
    }
}
