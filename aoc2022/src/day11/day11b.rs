#[cfg(test)]
mod tests {
    use crate::day11::day11a::{read_input, read_input_example, solve};

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input, 10_000, false, true);
        assert_eq!(result, 2713310158);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input, 10_000, false, true);
        assert_eq!(result, 32059801242);
    }
}
