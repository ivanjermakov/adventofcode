use crate::day8::day8a::*;

pub fn solve(input: String) -> i32 {
    let grid = parse_grid(input);
    let mut highest_score = 0i32;
    for (y, row) in grid.iter().enumerate() {
        for (x, tree) in row.iter().enumerate() {
            if x == 0 || x == row.len() - 1 {
                continue;
            }
            if y == 0 || y == grid.len() - 1 {
                continue;
            }
            let north = (0..y)
                .rev()
                .map(|dy| (x, dy))
                .map(|(dx, dy)| grid[dy][dx])
                .take_while(|t| tree > t)
                .count();
            let east = (x + 1..row.len())
                .map(|dx| (dx, y))
                .map(|(dx, dy)| grid[dy][dx])
                .take_while(|t| tree > t)
                .count();
            let south = (y + 1..grid.len())
                .map(|dy| (x, dy))
                .map(|(dx, dy)| grid[dy][dx])
                .take_while(|t| tree > t)
                .count();
            let west = (0..x)
                .rev()
                .map(|dx| (dx, y))
                .map(|(dx, dy)| grid[dy][dx])
                .take_while(|t| tree > t)
                .count();
            let vec = vec![
                north + if y - north == 0 { 0 } else { 1 },
                east + if x + east == row.len() - 1 { 0 } else { 1 },
                south + if y + south == grid.len() - 1 { 0 } else { 1 },
                west + if x - west == 0 { 0 } else { 1 },
            ];
            let score = vec.iter().fold(1, |acc, v| acc * v);
            if score as i32 > highest_score {
                highest_score = score as i32;
            }
        }
    }
    highest_score
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 8);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 268912);
    }
}
