use crate::day5::day5a::{get_top_crates, Move, parse_file};

pub fn apply_move(stacks: &mut Vec<String>, m: &Move) {
    let from_stack = &mut stacks[m.from - 1];
    let off: String = from_stack.drain(from_stack.len() - m.count..).collect();
    stacks[m.to - 1].push_str(off.as_str());
}

pub fn solve(input: String) -> String {
    let (mut stacks, moves) = parse_file(input);
    for m in moves {
        apply_move(&mut stacks, &m);
    }
    get_top_crates(stacks)
}

#[cfg(test)]
mod tests {
    use crate::day5::day5a::read_input;

    use super::*;

    #[test]
    fn should_solve_example() {
        let input = "ZN\nMCD\nP\n\nmove 1 from 2 to 1\nmove 3 from 1 to 3\nmove 2 from 2 to 1\nmove 1 from 1 to 2".to_string();
        let result = solve(input);
        assert_eq!(result, "MCD");
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, "LBBVJBRMH");
    }
}
