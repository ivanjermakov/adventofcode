use crate::day13::day13a::Item;
use crate::day13::day13a::Item::{IntItem, ListItem};

pub fn solve(input: Vec<Vec<Item>>) -> i32 {
    let p1 = ListItem(vec![ListItem(vec![IntItem(2)])]);
    let p2 = ListItem(vec![ListItem(vec![IntItem(6)])]);
    let mut lists: Vec<Item> = input.into_iter().flat_map(|p| p.into_iter()).collect();
    lists.push(p1.clone());
    lists.push(p2.clone());
    lists.sort();
    let p1_i = lists.iter().position(|i| i == &p1).unwrap() as i32 + 1;
    let p2_i = lists.iter().position(|i| i == &p2).unwrap() as i32 + 1;
    p1_i * p2_i
}

#[cfg(test)]
mod tests {
    use crate::day13::a::read_input;
    use crate::day13::example::read_input_example;

    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 140);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 24969);
    }
}
