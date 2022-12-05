use std::fs::read_to_string;

#[derive(Debug, PartialEq)]
pub struct Move {
    pub from: usize,
    pub to: usize,
    pub count: usize,
}

pub fn read_input() -> String {
    read_to_string("data/day5/a.txt").unwrap()
}

pub fn parse_file(input: String) -> (Vec<String>, Vec<Move>) {
    let tokens: Vec<&str> = input.trim().split("\n\n").collect();
    return (
        parse_stacks(tokens[0].to_string()),
        parse_moves(tokens[1].to_string()),
    );
}

pub fn parse_stacks(input: String) -> Vec<String> {
    input
        .trim()
        .split("\n")
        .map(|s| s.to_string())
        .collect::<Vec<String>>()
}

pub fn parse_moves(input: String) -> Vec<Move> {
    input
        .trim()
        .split("\n")
        .map(|l| {
            let words: Vec<&str> = l.split(" ").collect();
            Move {
                from: words[3].parse().unwrap(),
                to: words[5].parse().unwrap(),
                count: words[1].parse().unwrap(),
            }
        })
        .collect()
}

pub fn get_top_crates(stacks: Vec<String>) -> String {
    stacks.iter().map(|s| s.chars().last().unwrap()).collect()
}

pub fn apply_move(stacks: &mut Vec<String>, m: &Move) {
    let from_stack = &mut stacks[m.from - 1];
    let off: String = from_stack.drain(from_stack.len() - m.count..).collect();
    stacks[m.to - 1].push_str(off.chars().rev().collect::<String>().as_str());
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
    use super::*;

    #[test]
    fn should_parse_stacks() {
        let result = parse_stacks("ABC\nDE\nFGHI".to_string());
        assert_eq!(result, vec!["ABC", "DE", "FGHI"]);
    }

    #[test]
    fn should_parse_moves() {
        let result = parse_moves("move 1 from 6 to 1\nmove 3 from 7 to 4".to_string());
        assert_eq!(
            result,
            vec![
                Move {
                    from: 6,
                    to: 1,
                    count: 1,
                },
                Move {
                    from: 7,
                    to: 4,
                    count: 3,
                },
            ]
        );
    }

    #[test]
    fn should_get_top_crates() {
        let result = get_top_crates(parse_stacks("ABC\nDE\nFGHI".to_string()));
        assert_eq!(result, "CEI".to_string());
    }

    #[test]
    fn should_solve_example() {
        let input = "ZN\nMCD\nP\n\nmove 1 from 2 to 1\nmove 3 from 1 to 3\nmove 2 from 2 to 1\nmove 1 from 1 to 2".to_string();
        let result = solve(input);
        assert_eq!(result, "CMZ");
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, "VGBBJCRMN");
    }
}
