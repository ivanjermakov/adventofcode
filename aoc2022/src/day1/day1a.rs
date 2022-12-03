use std::fs::read_to_string;

pub fn read_input() -> String {
    read_to_string("data/day1/a.txt").unwrap()
}

pub fn solve(input: String) -> i32 {
    let elf_groups = parse_elfs(input);
    let c: Vec<i32> = elf_groups.iter().map(|g| g.iter().sum()).collect();
    *c.iter().max().unwrap()
}

pub fn parse_elfs(input: String) -> Vec<Vec<i32>> {
    input
        .trim()
        .split("\n\n")
        .map(|elf| elf.split("\n").map(|s| s.parse::<i32>().unwrap()).collect())
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_parse_elfs() {
        let input = "10\n20\n\n30\n40".to_string();
        let result = parse_elfs(input);
        assert_eq!(result, vec![vec![10, 20], vec![30, 40]]);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 68775);
    }
}
