use std::fs::read_to_string;

pub enum Command {
    Addx(i32),
    Noop,
}

pub fn read_input_example() -> String {
    read_to_string("data/day10/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day10/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String) -> i32 {
    let commands: Vec<Command> = input
        .split("\n")
        .map(|line| parse_command(line.to_string()))
        .collect();
    let mut x = 1i32;
    let mut cycle = 0i32;
    let mut strength = 0;
    for command in commands {
        cycle += 1;
        if cycle_check(cycle) {
            strength += cycle * x
        }
        match command {
            Command::Addx(r) => {
                cycle += 1;
                if cycle_check(cycle) {
                    strength += cycle * x
                }
                x += r;
            }
            Command::Noop => {}
        }
    }
    strength
}

fn cycle_check(cycle: i32) -> bool {
    cycle == 20 || (cycle + 20) % 40 == 0
}

pub fn parse_command(input: String) -> Command {
    let tokens = input.split(" ").collect::<Vec<&str>>();
    match tokens[0] {
        "addx" => Command::Addx(tokens[1].parse().unwrap()),
        "noop" => Command::Noop,
        _ => unreachable!(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 13140);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 14760);
    }
}
