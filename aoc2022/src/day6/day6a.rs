use std::collections::HashSet;
use std::fs::read_to_string;

pub fn read_input() -> String {
    read_to_string("data/day6/a.txt").unwrap()
}

pub fn solve(input: String, window_size: usize) -> usize {
    for i in 0..input.len() - window_size {
        let w = &input[i..i + window_size];
        if w.chars().collect::<HashSet<_>>().len() == window_size {
            return i + window_size;
        }
    }
    unreachable!()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        assert_eq!(solve("bvwbjplbgvbhsrlpgdmjqwftvncz".to_string(), 4), 5);
        assert_eq!(solve("nppdvjthqldpwncqszvftbrmjlhg".to_string(), 4), 6);
        assert_eq!(
            solve("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".to_string(), 4),
            10
        );
        assert_eq!(solve("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw".to_string(), 4), 11);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input, 4);
        assert_eq!(result, 1855);
    }
}
