use std::fs::read_to_string;

use crate::day10::day10a::*;

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

pub fn solve(input: String) -> String {
    let commands: Vec<Command> = input
        .split("\n")
        .map(|line| parse_command(line.to_string()))
        .collect();
    let mut x = 1i32;
    let mut cycle = 0i32;
    let mut ribbon = "".to_string();
    for command in commands {
        ribbon += get_char(x, cycle).as_str();
        cycle += 1;
        match command {
            Command::Addx(r) => {
                ribbon += get_char(x, cycle).as_str();
                cycle += 1;
                x += r;
            }
            Command::Noop => {}
        }
    }
    ribbon
        .chars()
        .collect::<Vec<char>>()
        .chunks(40)
        .map(|c| c.iter().collect::<String>())
        .collect::<Vec<String>>()
        .join("\n")
}

fn get_char(x: i32, cycle: i32) -> String {
    if ((cycle % 40) - x).abs() < 2 {
        "#"
    } else {
        " "
    }
    .to_string()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let expected = r#"##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
###   ###   ###   ###   ###   ###   ### 
####    ####    ####    ####    ####    
#####     #####     #####     #####     
######      ######      ######      ####
#######       #######       #######     "#;
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, expected);
    }

    #[test]
    fn should_solve() {
        let expected = r#"#### ####  ##  #### ###  #  # ###  #### 
#    #    #  # #    #  # #  # #  # #    
###  ###  #    ###  #  # #  # #  # ###  
#    #    # ## #    ###  #  # ###  #    
#    #    #  # #    # #  #  # # #  #    
#### #     ### #### #  #  ##  #  # #### "#;
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, expected);
    }
}
