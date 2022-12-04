use std::fs::read_to_string;

#[derive(Debug, PartialEq, Copy, Clone)]
pub enum Shape {
    Rock,
    Paper,
    Scissors,
}

#[derive(Debug, PartialEq, Copy, Clone)]
pub struct Round(Shape, Outcome, Option<Shape>);

#[derive(Debug, PartialEq, Copy, Clone)]
pub enum Outcome {
    Win,
    Lose,
    Draw,
}

pub fn read_input() -> String {
    read_to_string("data/day2/a.txt").unwrap()
}

pub fn parse_rounds(input: String) -> Vec<Round> {
    input
        .trim()
        .split("\n")
        .map(|round| {
            let tokens: Vec<&str> = round.split(" ").collect();
            Round(
                parse_shape(tokens[0]).unwrap(),
                parse_outcome(tokens[1]).unwrap(),
                None,
            )
        })
        .collect()
}

pub fn parse_shape(token: &str) -> Option<Shape> {
    match token {
        "A" => Some(Shape::Rock),
        "B" => Some(Shape::Paper),
        "C" => Some(Shape::Scissors),
        _ => None,
    }
}

pub fn parse_outcome(token: &str) -> Option<Outcome> {
    match token {
        "X" => Some(Outcome::Lose),
        "Y" => Some(Outcome::Draw),
        "Z" => Some(Outcome::Win),
        _ => None,
    }
}

pub fn get_round_score(round: Round) -> i32 {
    let outcome_score = match round.1 {
        Outcome::Win => 6,
        Outcome::Lose => 0,
        Outcome::Draw => 3,
    };
    let shape_score = match round.2.unwrap() {
        Shape::Rock => 1,
        Shape::Paper => 2,
        Shape::Scissors => 3,
    };
    outcome_score + shape_score
}

pub fn guess_player_shape(round: Round) -> Shape {
    if round.1 == Outcome::Draw {
        return round.0;
    }
    match round {
        Round(Shape::Rock, Outcome::Win, _) => Shape::Paper,
        Round(Shape::Paper, Outcome::Win, _) => Shape::Scissors,
        Round(Shape::Scissors, Outcome::Win, _) => Shape::Rock,
        Round(Shape::Rock, Outcome::Lose, _) => Shape::Scissors,
        Round(Shape::Paper, Outcome::Lose, _) => Shape::Rock,
        Round(Shape::Scissors, Outcome::Lose, _) => Shape::Paper,
        _ => unreachable!(),
    }
}

pub fn solve(input: String) -> i32 {
    parse_rounds(input)
        .iter_mut()
        .map(|round| {
            round.2 = Some(guess_player_shape(*round));
            round
        })
        .map(|round| get_round_score(*round))
        .sum()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_parse_rounds() {
        let input = "A Y\nB X\nC Z".to_string();
        let result = parse_rounds(input);
        assert_eq!(
            result,
            vec![
                Round(Shape::Rock, Outcome::Draw, None),
                Round(Shape::Paper, Outcome::Lose, None),
                Round(Shape::Scissors, Outcome::Win, None),
            ]
        );
    }

    #[test]
    fn should_solve_example() {
        let input = "A Y\nB X\nC Z".to_string();
        let result = solve(input);
        assert_eq!(result, 12);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 14470);
    }
}
