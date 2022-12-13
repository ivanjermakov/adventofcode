use std::cmp::Ordering;
use std::iter::zip;

use crate::day13::day13a::Item::{IntItem, ListItem};

#[derive(Debug, PartialOrd, PartialEq, Clone)]
pub struct List(pub Item);

#[derive(Debug, Ord, PartialEq, Eq, Clone)]
pub enum Item {
    ListItem(Vec<Item>),
    IntItem(i32),
}

impl PartialOrd for Item {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(compare(self, other))
    }
}

pub fn solve(input: Vec<Vec<Item>>) -> i32 {
    let orderings: Vec<Ordering> = input
        .into_iter()
        .map(|pair| pair[0].partial_cmp(&pair[1]).unwrap())
        .collect();
    orderings
        .into_iter()
        .enumerate()
        .filter(|(_, ord)| ord == &Ordering::Less)
        .map(|(i, _)| i as i32 + 1)
        .sum()
}

pub fn compare(a: &Item, b: &Item) -> Ordering {
    return match (a, b) {
        (ListItem(a_l), ListItem(b_l)) => {
            for (a_i, b_i) in zip(a_l, b_l).into_iter() {
                let ord = compare(a_i, b_i);
                if ord != Ordering::Equal {
                    return ord;
                }
            }
            a_l.len().cmp(&b_l.len())
        }
        (IntItem(a_i), IntItem(b_i)) => a_i.cmp(&b_i),
        (ListItem(_), IntItem(_)) => compare(a, &ListItem(vec![b.clone()])),
        (IntItem(_), ListItem(_)) => compare(&ListItem(vec![a.clone()]), b),
    };
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
        assert_eq!(result, 13);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 5605);
    }
}
