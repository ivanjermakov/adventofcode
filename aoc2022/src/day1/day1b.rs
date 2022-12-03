use crate::day1::day1a::parse_elfs;

pub fn solve(input: String) -> i32 {
    let elf_groups = parse_elfs(input);
    let mut c: Vec<i32> = elf_groups.iter().map(|g| g.iter().sum()).collect();
    c.sort_by(|a, b| b.cmp(a));
    c.iter().take(3).sum::<i32>()
}

#[cfg(test)]
mod tests {
    use crate::day1::day1a::read_input;

    use super::*;

    #[test]
    fn test1() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 202585);
    }
}
