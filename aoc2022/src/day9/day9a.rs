use std::fs::read_to_string;

use crate::day9::day9a::Move::*;

#[derive(Debug, PartialEq, Clone, Copy)]
pub enum Move {
    Up,
    Right,
    Down,
    Left,
}

#[derive(Debug, PartialEq, Ord, PartialOrd, Eq, Clone, Copy)]
pub struct Vec2 {
    pub x: i32,
    pub y: i32,
}

pub fn read_input_example() -> String {
    read_to_string("data/day9/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day9/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String) -> i32 {
    let moves = parse_moves(input);
    let mut head_pos = Vec2 { x: 0, y: 0 };
    let mut tail_pos = Vec2 { x: 0, y: 0 };
    let mut tail_hist = vec![tail_pos.clone()];
    for m in moves {
        head_pos = pos_after_move(&head_pos, m);
        tail_pos = get_new_tail_location(&head_pos, &tail_pos);
        tail_hist.push(tail_pos.clone());
    }
    tail_hist.sort();
    tail_hist.dedup();
    tail_hist.len() as i32
}

pub fn pos_after_move(pos: &Vec2, m: Move) -> Vec2 {
    match m {
        Up => Vec2 {
            x: pos.x,
            y: pos.y + 1,
        },
        Right => Vec2 {
            x: pos.x + 1,
            y: pos.y,
        },
        Down => Vec2 {
            x: pos.x,
            y: pos.y - 1,
        },
        Left => Vec2 {
            x: pos.x - 1,
            y: pos.y,
        },
    }
}

pub fn parse_moves(input: String) -> Vec<Move> {
    input
        .split("\n")
        .map(|l| {
            let tokens: Vec<&str> = l.split(" ").collect();
            let dir: Move = match tokens[0] {
                "U" => Up,
                "R" => Right,
                "D" => Down,
                "L" => Left,
                _ => unreachable!(),
            };
            let count = tokens[1].parse::<usize>().unwrap();
            vec![dir; count]
        })
        .flat_map(|v| v)
        .collect()
}

pub fn get_new_tail_location(head: &Vec2, tail: &Vec2) -> Vec2 {
    if is_adjacent(head, tail) {
        return tail.clone();
    }
    // diagonal
    let dx = head.x - tail.x;
    let dy = head.y - tail.y;
    if dx.abs() > 0 && dy.abs() > 0 {
        return Vec2 {
            x: tail.x + normalize(dx),
            y: tail.y + normalize(dy),
        };
    }
    if dx.abs() > 1 {
        return Vec2 {
            x: tail.x + normalize(dx),
            y: tail.y,
        };
    }
    if dy.abs() > 1 {
        return Vec2 {
            x: tail.x,
            y: tail.y + normalize(dy),
        };
    }
    unreachable!()
}

pub fn normalize(a: i32) -> i32 {
    if a > 0 {
        1
    } else {
        -1
    }
}

pub fn is_adjacent(a: &Vec2, b: &Vec2) -> bool {
    if (a.x - b.x).abs() > 1 || (a.y - b.y).abs() > 1 {
        return false;
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_parse_moves() {
        let input = read_input_example();
        let result = parse_moves(input);
        assert_eq!(
            result,
            vec![
                Right, Right, Right, Right, Up, Up, Up, Up, Left, Left, Left, Down, Right, Right,
                Right, Right, Down, Left, Left, Left, Left, Left, Right, Right,
            ]
        );
    }

    #[test]
    fn should_get_new_tail_location() {
        let result = get_new_tail_location(&Vec2 { x: 0, y: 0 }, &Vec2 { x: 0, y: 0 });
        assert_eq!(result, Vec2 { x: 0, y: 0 });

        let result = get_new_tail_location(&Vec2 { x: 0, y: 0 }, &Vec2 { x: 1, y: 1 });
        assert_eq!(result, Vec2 { x: 1, y: 1 });

        let result = get_new_tail_location(&Vec2 { x: 0, y: 0 }, &Vec2 { x: 2, y: 0 });
        assert_eq!(result, Vec2 { x: 1, y: 0 });

        let result = get_new_tail_location(&Vec2 { x: 0, y: 0 }, &Vec2 { x: 2, y: 2 });
        assert_eq!(result, Vec2 { x: 1, y: 1 });

        let result = get_new_tail_location(&Vec2 { x: 0, y: 0 }, &Vec2 { x: 2, y: 3 });
        assert_eq!(result, Vec2 { x: 1, y: 2 });

        let result = get_new_tail_location(&Vec2 { x: 0, y: 0 }, &Vec2 { x: 3, y: 2 });
        assert_eq!(result, Vec2 { x: 2, y: 1 });
    }

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 13);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 5960);
    }
}
