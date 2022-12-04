use std::ops::Range;

use crate::day4::day4a::{parse_pair, Pair};

pub fn solve(input: String) -> i32 {
    input
        .trim()
        .split("\n")
        .map(|line| parse_pair(line))
        .map(|pair| check_intersect(pair) as i32)
        .sum()
}

pub fn check_intersect(pair: Pair) -> bool {
    let check = |a: &Range<i32>, b: &Range<i32>| a.start <= b.end && a.end >= b.start;
    check(&pair.0, &pair.1) || check(&pair.1, &pair.0)
}

#[cfg(test)]
mod tests {
    use crate::day4::day4a::read_input;

    use super::*;

    #[test]
    fn should_check_intersect() {
        assert_eq!(check_intersect(parse_pair("2-4,6-8")), false);
        assert_eq!(check_intersect(parse_pair("2-3,4-5")), false);
        assert_eq!(check_intersect(parse_pair("5-7,7-9")), true);
        assert_eq!(check_intersect(parse_pair("2-8,3-7")), true);
        assert_eq!(check_intersect(parse_pair("6-6,4-6")), true);
        assert_eq!(check_intersect(parse_pair("2-6,4-8")), true);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 914);
    }
}
