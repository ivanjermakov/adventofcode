use std::fs::read_to_string;

pub fn read_input_example() -> String {
    read_to_string("data/day20/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day20/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(nums: &Vec<i128>, iterations: usize, multiplier: i128) -> i128 {
    let mut nums: Vec<(i128, i128)> = nums
        .iter()
        .enumerate()
        .map(|(i, x)| (i as i128, *x as i128 * multiplier))
        .collect();
    let l = nums.len() as i128;
    for _ in 0..iterations {
        for i in 0..l {
            let curr_index = nums.iter().position(|(idx, _)| *idx == i).unwrap();
            let x = nums.remove(curr_index);
            let new_index = curr_index as i128 + x.1 + 1_000_000_000_000 * (l - 1);
            nums.insert((new_index % (l - 1)) as usize, x);
        }
    }
    let nums: Vec<i128> = nums.iter().map(|(_, x)| *x).collect();
    let zero_index = nums.iter().position(|x| x == &0).unwrap() as i128;
    [1000, 2000, 3000]
        .iter()
        .map(|i| nums[((zero_index + i) % l) as usize])
        .sum()
}

pub fn parse_nums(input: String) -> Vec<i128> {
    input
        .split("\n")
        .map(|l| l.parse::<i128>().unwrap())
        .collect::<Vec<_>>()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(&parse_nums(input), 1, 1);
        assert_eq!(result, 3);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(&parse_nums(input), 1, 1);
        assert_eq!(result, 15297);
    }
}
