#[cfg(test)]
mod tests {
    use crate::day6::day6a::{read_input, solve};

    #[test]
    fn should_solve_example() {
        assert_eq!(solve("bvwbjplbgvbhsrlpgdmjqwftvncz".to_string(), 14), 23);
        assert_eq!(solve("nppdvjthqldpwncqszvftbrmjlhg".to_string(), 14), 23);
        assert_eq!(
            solve("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".to_string(), 14),
            29
        );
        assert_eq!(
            solve("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw".to_string(), 14),
            26
        );
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input, 14);
        assert_eq!(result, 3256);
    }
}
