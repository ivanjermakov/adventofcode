#[cfg(test)]
mod tests {
    use crate::day20::day20a::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(&parse_nums(input), 10, 811_589_153);
        assert_eq!(result, 1_623_178_306);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(&parse_nums(input), 10, 811_589_153);
        assert_eq!(result, 2_897_373_276_210);
    }
}
