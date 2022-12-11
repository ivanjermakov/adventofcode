use std::fs::read_to_string;

#[derive(Debug, PartialOrd, PartialEq, Clone)]
pub struct Monkey {
    items: Vec<i64>,
    operation: String,
    divisible_by: i64,
    true_to_m: i64,
    false_to_m: i64,
    inspect_count: i64,
}

pub fn read_input_example() -> String {
    read_to_string("data/day11/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day11/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String, rounds: usize, reduce_stress: bool, cap: bool) -> i64 {
    let mut ms = parse_file(input);
    let cap_v: i64 = 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23;
    for _ in 0..rounds {
        for m_i in 0..ms.len() {
            for _ in 0..ms[m_i].items.len() {
                let v: i64 = match ms[m_i].operation.split(" ").collect::<Vec<&str>>()[1] {
                    "old" => ms[m_i].items[0],
                    p => p.parse().unwrap(),
                };
                let op = ms[m_i].operation.split(" ").collect::<Vec<&str>>()[0];
                ms[m_i].items[0] = match op {
                    "+" => ms[m_i].items[0] + v,
                    "*" => ms[m_i].items[0] * v,
                    _ => unreachable!(),
                };
                if cap {
                    ms[m_i].items[0] %= cap_v
                }
                ms[m_i].inspect_count += 1;
                if reduce_stress {
                    ms[m_i].items[0] /= 3;
                }
                let it = *ms[m_i].items.first().unwrap();
                if it % ms[m_i].divisible_by == 0 {
                    let m = ms[m_i].true_to_m;
                    ms[m as usize].items.push(it);
                } else {
                    let m = ms[m_i].false_to_m;
                    ms[m as usize].items.push(it);
                }
                ms[m_i].items.remove(0);
            }
        }
    }
    ms.sort_by_key(|m| m.inspect_count);
    ms.reverse();
    ms.into_iter()
        .take(2)
        .map(|m| m.inspect_count)
        .fold(1i64, |acc, i| acc * i)
}

pub fn parse_file(input: String) -> Vec<Monkey> {
    input
        .split("\n\n")
        .map(|g| {
            let tokens = g.split("\n").collect::<Vec<&str>>();
            Monkey {
                items: tokens[0]
                    .split(", ")
                    .map(|i| i.parse::<i64>().unwrap())
                    .collect(),
                operation: tokens[1].to_string(),
                divisible_by: tokens[2].parse().unwrap(),
                true_to_m: tokens[3].parse().unwrap(),
                false_to_m: tokens[4].parse().unwrap(),
                inspect_count: 0,
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input, 20, true, false);
        assert_eq!(result, 10605);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input, 20, true, false);
        assert_eq!(result, 120384);
    }
}
