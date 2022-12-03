use std::fs::read_to_string;

use crate::day2::day2a::Outcome::Draw;

#[derive(Debug, PartialEq, Copy, Clone)]
pub enum Shape {
    Rock,
    Paper,
    Scissors,
}

#[derive(Debug, PartialEq, Copy, Clone)]
pub struct Round(Shape, Shape);

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
            let shapes: Vec<Shape> = round
                .split(" ")
                .map(|shape| parse_shape(shape).unwrap())
                .collect();
            Round(shapes[0], shapes[1])
        })
        .collect()
}

pub fn parse_shape(shape: &str) -> Option<Shape> {
    match shape {
        "A" => Some(Shape::Rock),
        "X" => Some(Shape::Rock),
        "B" => Some(Shape::Paper),
        "Y" => Some(Shape::Paper),
        "C" => Some(Shape::Scissors),
        "Z" => Some(Shape::Scissors),
        _ => None,
    }
}

pub fn get_round_score(round: Round) -> i32 {
    let outcome = get_round_outcome(round);
    let outcome_score = match outcome {
        Outcome::Win => 6,
        Outcome::Lose => 0,
        Draw => 3,
    };
    let shape_score = match round.1 {
        Shape::Rock => 1,
        Shape::Paper => 2,
        Shape::Scissors => 3,
    };
    outcome_score + shape_score
}

pub fn get_round_outcome(round: Round) -> Outcome {
    if round.0 == round.1 {
        return Draw;
    }
    match round {
        Round(Shape::Rock, Shape::Paper) => Some(Outcome::Win),
        Round(Shape::Rock, Shape::Scissors) => Some(Outcome::Lose),
        Round(Shape::Paper, Shape::Scissors) => Some(Outcome::Win),
        Round(Shape::Paper, Shape::Rock) => Some(Outcome::Lose),
        Round(Shape::Scissors, Shape::Rock) => Some(Outcome::Win),
        Round(Shape::Scissors, Shape::Paper) => Some(Outcome::Lose),
        Round(_, _) => None,
    }
    .unwrap()
}

pub fn solve(input: String) -> i32 {
    let rounds = parse_rounds(input);
    rounds.iter().map(|round| get_round_score(*round)).sum()
}

#[cfg(test)]
mod tests {
    use crate::day2::day2a::Shape::{Paper, Rock, Scissors};

    use super::*;

    #[test]
    fn should_parse_rounds() {
        let input = "A Y\nB X\nC Z".to_string();
        let result = parse_rounds(input);
        assert_eq!(
            result,
            vec![
                Round(Rock, Paper),
                Round(Paper, Rock),
                Round(Scissors, Scissors),
            ]
        );
    }

    #[test]
    fn should_solve_example() {
        let input = "A Y\nB X\nC Z".to_string();
        let result = solve(input);
        assert_eq!(result, 15);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 12679);
    }
}
