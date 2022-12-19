use crate::day19::day19a::{optimize, parse_blueprint, Resources, Robots};

pub fn solve(input: String) -> i32 {
    let bps = input
        .split("\n")
        .map(|l| parse_blueprint(l.to_string()))
        .collect::<Vec<_>>();
    let mut result = 1;
    for bp in 0..3 {
        let res = optimize(
            &bps[bp],
            &Resources {
                ore: 0,
                clay: 0,
                obsidian: 0,
                geode: 0,
            },
            &Robots {
                ore_robots: 1,
                clay_robots: 0,
                obsidian_robots: 0,
                geode_robots: 0,
            },
            32,
        );
        result += res.geode
    }
    result
}

#[cfg(test)]
mod tests {
    use crate::day19::day19a::read_input;

    use super::*;

    #[test]
    #[ignore]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 0);
    }
}
