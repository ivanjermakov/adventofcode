use crate::day9::day9a::{get_new_tail_location, parse_moves, pos_after_move, Vec2};

pub fn solve(input: String) -> i32 {
    let moves = parse_moves(input);
    let mut elems = vec![Vec2 { x: 0, y: 0 }; 10];
    let mut tail_hist = vec![elems[9].clone()];
    for m in moves {
        let head = &mut elems[0];
        *head = pos_after_move(head, m);
        for i in 1..elems.len() {
            elems[i] = get_new_tail_location(&elems[i - 1], &elems[i]);
            if i == elems.len() - 1 {
                tail_hist.push(elems[i].clone());
            }
        }
    }
    tail_hist.sort();
    tail_hist.dedup();
    tail_hist.len() as i32
}

#[cfg(test)]
mod tests {
    use crate::day9::day9a::read_input;

    use super::*;

    #[test]
    fn should_solve_example() {
        let result = solve("R 5\nU 8\nL 8\nD 3\nR 17\nD 10\nL 25\nU 20".to_string());
        assert_eq!(result, 36);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 2327);
    }
}
