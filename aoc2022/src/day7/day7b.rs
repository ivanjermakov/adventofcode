use crate::day7::day7a::*;

pub fn solve(input: String) -> u32 {
    let total_size: u32 = 70_000_000;
    let required_size: u32 = 30_000_000;

    let commands = parse_commands(input);
    let tree = parse_tree(commands);

    let total_used: u32 = get_size(&tree);
    let unused_size = total_size - total_used;
    let to_delete_size = required_size - unused_size;

    let mut sizes = flatten_dirs(&tree)
        .iter()
        .map(|dir| get_size(dir))
        .collect::<Vec<u32>>();

    sizes.sort();

    sizes
        .into_iter()
        .filter(|s| *s >= to_delete_size)
        .next()
        .unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 24933642);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 3579501);
    }
}
