use std::fs::read_to_string;

pub fn read_input_example() -> String {
    read_to_string("data/day8/example.txt").unwrap()
}

pub fn read_input() -> String {
    read_to_string("data/day8/a.txt").unwrap()
}

pub fn solve(input: String) -> i32 {
    let grid = parse_grid(input);
    let mut count = 0i32;
    for (y, row) in grid.iter().enumerate() {
        for (x, tree) in row.iter().enumerate() {
            if x == 0 || x == row.len() - 1 {
                count += 1;
                continue;
            }
            if y == 0 || y == grid.len() - 1 {
                count += 1;
                continue;
            }
            let north = (0..y)
                .map(|dy| (x, dy))
                .map(|(dx, dy)| grid[dy][dx])
                .all(|t| *tree > t);
            let east = (x + 1..row.len())
                .map(|dx| (dx, y))
                .map(|(dx, dy)| grid[dy][dx])
                .all(|t| *tree > t);
            let south = (y + 1..grid.len())
                .map(|dy| (x, dy))
                .map(|(dx, dy)| grid[dy][dx])
                .all(|t| *tree > t);
            let west = (0..x)
                .map(|dx| (dx, y))
                .map(|(dx, dy)| grid[dy][dx])
                .all(|t| *tree > t);
            if north || east || south || west {
                count += 1;
            }
        }
    }
    count
}

pub fn parse_grid(input: String) -> Vec<Vec<i32>> {
    input
        .trim()
        .split("\n")
        .map(|line| {
            line.chars()
                .map(|c| c.to_digit(10).unwrap() as i32)
                .collect()
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 21);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 1803);
    }
}
