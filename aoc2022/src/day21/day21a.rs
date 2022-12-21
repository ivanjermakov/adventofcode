use std::collections::HashMap;
use std::fs::read_to_string;

#[derive(Debug, PartialEq, Ord, PartialOrd, Eq, Clone, Hash)]
pub enum Expression {
    Value(String, i128),
    Expression(String, String, char, String),
}

pub fn read_input_example() -> String {
    read_to_string("data/day21/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day21/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String) -> i128 {
    let expressions = input
        .split("\n")
        .map(|l| parse_expression(l.to_string()))
        .map(|exp| match &exp {
            Expression::Value(id, _) => (id.clone(), exp.clone()),
            Expression::Expression(id, _, _, _) => (id.clone(), exp.clone()),
        })
        .collect::<HashMap<String, Expression>>();
    println!("{:?}", expressions);
    evaluate(&expressions, "root".to_string())
}

pub fn evaluate(map: &HashMap<String, Expression>, id: String) -> i128 {
    let exp = map.get(id.as_str()).unwrap();
    match exp {
        Expression::Value(_, v) => v.clone(),
        Expression::Expression(_, a, o, b) => match o {
            '+' => evaluate(map, a.clone()) + evaluate(map, b.clone()),
            '-' => evaluate(map, a.clone()) - evaluate(map, b.clone()),
            '*' => evaluate(map, a.clone()) * evaluate(map, b.clone()),
            '/' => evaluate(map, a.clone()) / evaluate(map, b.clone()),
            _ => unreachable!(),
        },
    }
}

pub fn parse_expression(input: String) -> Expression {
    let id_body = input.split(": ").collect::<Vec<_>>();
    let id = id_body[0];
    if let Ok(num) = id_body[1].parse::<i128>() {
        return Expression::Value(id.to_string(), num);
    }
    let tokens = id_body[1].split(" ").collect::<Vec<_>>();
    return Expression::Expression(
        id.to_string(),
        tokens[0].to_string(),
        tokens[1].chars().nth(0).unwrap(),
        tokens[2].to_string(),
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 152);
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 87457751482938);
    }
}
