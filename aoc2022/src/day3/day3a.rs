use std::fs::read_to_string;

#[derive(Debug, PartialEq)]
pub struct Backpack(String, String);

pub fn read_input() -> String {
    read_to_string("data/day3/a.txt").unwrap()
}

pub fn solve(input: String) -> i32 {
    let backpacks: Vec<Backpack> = input
        .trim()
        .split("\n")
        .map(|line| parse_backpack(line.to_string()))
        .collect();
    backpacks
        .iter()
        .map(|backpack| find_repeated_item(backpack))
        .filter(|item| item.is_some())
        .map(|item| to_priority(item.unwrap()))
        .sum()
}

pub fn find_repeated_item(backpack: &Backpack) -> Option<char> {
    backpack.0.chars().find(|c| backpack.1.contains(*c))
}

pub fn parse_backpack(input: String) -> Backpack {
    let left = input[..input.len() / 2].to_string();
    let right = input[input.len() / 2..].to_string();
    Backpack(left, right)
}

pub fn to_priority(char: char) -> i32 {
    char as i32 - (if char.is_ascii_uppercase() { 38 } else { 96 })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_convert_to_priority() {
        assert_eq!(to_priority('a'), 1);
        assert_eq!(to_priority('z'), 26);
        assert_eq!(to_priority('A'), 27);
        assert_eq!(to_priority('Z'), 52);
    }

    #[test]
    fn should_parse_backpack() {
        assert_eq!(
            parse_backpack("abcdABCD".to_string()),
            Backpack("abcd".to_string(), "ABCD".to_string())
        );
    }

    #[test]
    fn should_find_repeated_item() {
        assert_eq!(
            find_repeated_item(&parse_backpack("vJrwpWtwJgWrhcsFMMfFFhFp".to_string())),
            Some('p')
        );
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 8109);
    }
}
