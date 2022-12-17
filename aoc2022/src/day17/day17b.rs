pub fn solve(input: String) -> i32 {
    todo!()
}

#[cfg(test)]
mod tests {
    use crate::day17::day17a::{read_input, read_input_example};

    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 0);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 0);
    }
}
