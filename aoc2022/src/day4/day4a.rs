use std::fs::read_to_string;
use std::ops::Range;

#[derive(Debug, PartialEq)]
pub struct Pair(pub Range<i32>, pub Range<i32>);

pub fn read_input() -> String {
    read_to_string("data/day4/a.txt").unwrap()
}

pub fn solve(input: String) -> i32 {
    input
        .trim()
        .split("\n")
        .map(|line| parse_pair(line))
        .map(|pair| check_full_intersect(pair) as i32)
        .sum()
}

pub fn parse_pair(input: &str) -> Pair {
    let tokens: Vec<&str> = input.split(",").collect();
    Pair(parse_range(tokens[0]), parse_range(tokens[1]))
}

fn parse_range(input: &str) -> Range<i32> {
    let tokens: Vec<i32> = input
        .split("-")
        .map(|token| token.parse::<i32>().unwrap())
        .collect();
    tokens[0]..tokens[1]
}

pub fn check_full_intersect(pair: Pair) -> bool {
    let check = |a: &Range<i32>, b: &Range<i32>| a.start >= b.start && a.end <= b.end;
    check(&pair.0, &pair.1) || check(&pair.1, &pair.0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_parse_pair() {
        let result = parse_pair("21-82,22-81");
        assert_eq!(result, Pair(21..82, 22..81));
    }

    #[test]
    fn should_check_intersect() {
        assert_eq!(check_full_intersect(parse_pair("2-4,6-8")), false);
        assert_eq!(check_full_intersect(parse_pair("2-3,4-5")), false);
        assert_eq!(check_full_intersect(parse_pair("5-7,7-9")), false);
        assert_eq!(check_full_intersect(parse_pair("2-8,3-7")), true);
        assert_eq!(check_full_intersect(parse_pair("6-6,4-6")), true);
        assert_eq!(check_full_intersect(parse_pair("2-6,4-8")), false);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 605);
    }
}
