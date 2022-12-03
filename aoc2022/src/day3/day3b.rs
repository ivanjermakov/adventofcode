use std::fs::read_to_string;

pub fn solve(input: String) -> i32 {
    let lines: Vec<&str> = input.trim().split("\n").collect();
    let groups: Vec<Vec<&str>> = lines.chunks(3).map(|s| s.to_vec()).collect();
    groups
        .iter()
        .map(|group| find_repeated_item(group))
        .map(|item| to_priority(item.unwrap()))
        .sum()
}

pub fn find_repeated_item(group: &Vec<&str>) -> Option<char> {
    group[0]
        .chars()
        .find(|c| group[1].contains(*c) && group[2].contains(*c))
}

pub fn to_priority(char: char) -> i32 {
    char as i32 - (if char.is_ascii_uppercase() { 38 } else { 96 })
}

#[cfg(test)]
mod tests {
    use crate::day3::day3a::read_input;

    use super::*;

    #[test]
    fn should_convert_to_priority() {
        assert_eq!(to_priority('a'), 1);
        assert_eq!(to_priority('z'), 26);
        assert_eq!(to_priority('A'), 27);
        assert_eq!(to_priority('Z'), 52);
    }

    #[test]
    fn should_find_repeated_item() {
        assert_eq!(
            find_repeated_item(&vec![
                "vJrwpWtwJgWrhcsFMMfFFhFp",
                "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
                "PmmdzqPrVvPwwTWBwg",
            ]),
            Some('r')
        );
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 2738);
    }
}
