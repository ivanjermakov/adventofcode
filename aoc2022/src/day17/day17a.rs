use crate::day9::day9a::Vec2;
use std::collections::HashSet;
use std::fs::read_to_string;

pub fn read_input_example() -> String {
    read_to_string("data/day17/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day17/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub type Shape = Vec<Vec2>;

pub fn shapes() -> Vec<Shape> {
    vec![
        vec![
            Vec2 { x: 0, y: 0 },
            Vec2 { x: 1, y: 0 },
            Vec2 { x: 2, y: 0 },
            Vec2 { x: 3, y: 0 },
        ],
        vec![
            Vec2 { x: 1, y: -2 },
            Vec2 { x: 0, y: -1 },
            Vec2 { x: 1, y: -1 },
            Vec2 { x: 2, y: -1 },
            Vec2 { x: 1, y: 0 },
        ],
        vec![
            Vec2 { x: 2, y: -2 },
            Vec2 { x: 2, y: -1 },
            Vec2 { x: 0, y: 0 },
            Vec2 { x: 1, y: 0 },
            Vec2 { x: 2, y: 0 },
        ],
        vec![
            Vec2 { x: 0, y: -3 },
            Vec2 { x: 0, y: -2 },
            Vec2 { x: 0, y: -1 },
            Vec2 { x: 0, y: 0 },
        ],
        vec![
            Vec2 { x: 0, y: -1 },
            Vec2 { x: 1, y: -1 },
            Vec2 { x: 0, y: 0 },
            Vec2 { x: 1, y: 0 },
        ],
    ]
}

pub fn solve(input: String) -> i32 {
    let shapes: Vec<Shape> = shapes();
    let mut grid = HashSet::new();
    let mut off = 0;
    for p in 0..2022 {
        let (g, o) = drop(&grid, &shapes[p % shapes.len()], &input, off);
        grid.extend(g);
        off = o;
    }
    -highest_occupied_y(&grid) + 1
}

pub fn highest_occupied_y(occupied: &HashSet<Vec2>) -> i32 {
    let mut ys: Vec<i32> = occupied.into_iter().map(|p| p.y).collect();
    ys.sort();
    *ys.first().unwrap_or(&1)
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

pub fn is_legal(shape: &Shape, delta: &Vec2, occupied: &HashSet<Vec2>) -> bool {
    for p in shape {
        let rp = Vec2 {
            x: p.x + delta.x,
            y: p.y + delta.y,
        };
        if rp.y > 0 || rp.x > 6 || rp.x < 0 {
            return false;
        }
        if occupied.contains(&rp) {
            return false;
        };
    }
    return true;
}

pub fn format_tower(occupied: &HashSet<Vec2>) -> String {
    let m_y = highest_occupied_y(occupied);
    let mut s = "".to_string();
    println!("{:?}", occupied);
    for y in (0..-m_y + 1).rev() {
        for x in 0..7 {
            let pos = Vec2 { x, y: -y };
            if occupied.contains(&pos) {
                s += "#";
            } else {
                s += ".";
            }
        }
        s += "\n";
    }
    s
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 3068);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 3239);
    }
}
