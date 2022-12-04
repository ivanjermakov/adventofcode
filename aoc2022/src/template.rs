use std::fs::read_to_string;

pub fn read_input() -> String {
    read_to_string("data/dayN/a.txt").unwrap()
}

pub fn solve(input: String) -> i32 {
    todo!()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 8109);
    }
}
