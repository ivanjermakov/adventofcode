use std::fs::read_to_string;

#[derive(Debug, PartialEq, Ord, PartialOrd, Eq, Clone, Copy, Hash)]
pub struct Blueprint {
    pub id: i32,
    pub ore_robot: Resources,
    pub clay_robot: Resources,
    pub obsidian_robot: Resources,
    pub geode_robot: Resources,
}

#[derive(Debug, PartialEq, Ord, PartialOrd, Eq, Clone, Copy, Hash)]
pub struct Resources {
    pub ore: i32,
    pub clay: i32,
    pub obsidian: i32,
    pub geode: i32,
}

#[derive(Debug, PartialEq, Ord, PartialOrd, Eq, Clone, Copy, Hash)]
pub struct Robots {
    pub ore_robots: i32,
    pub clay_robots: i32,
    pub obsidian_robots: i32,
    pub geode_robots: i32,
}

impl Robots {
    fn add_robots(&self, r: &Robots) -> Robots {
        Robots {
            ore_robots: self.ore_robots + r.ore_robots,
            clay_robots: self.clay_robots + r.clay_robots,
            obsidian_robots: self.obsidian_robots + r.obsidian_robots,
            geode_robots: self.geode_robots + r.geode_robots,
        }
    }
}

impl Resources {
    fn add(&self, r: &Robots) -> Resources {
        Resources {
            ore: self.ore + r.ore_robots,
            clay: self.clay + r.clay_robots,
            obsidian: self.obsidian + r.obsidian_robots,
            geode: self.geode + r.geode_robots,
        }
    }

    fn subtract(&self, r: &Resources) -> Resources {
        Resources {
            ore: self.ore - r.ore,
            clay: self.clay - r.clay,
            obsidian: self.obsidian - r.obsidian,
            geode: self.geode - r.geode,
        }
    }

    fn valid(&self) -> bool {
        self.ore >= 0 && self.clay >= 0 && self.obsidian >= 0 && self.geode >= 0
    }
}

pub fn read_input_example() -> String {
    read_to_string("data/day19/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day19/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String) -> i32 {
    let bps = input
        .split("\n")
        .map(|l| parse_blueprint(l.to_string()))
        .collect::<Vec<_>>();
    let mut result = 0;
    for bp in bps {
        let res = optimize(
            &bp,
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
            24,
            false,
        );
        result += bp.id * res.geode
    }
    result
}

pub fn optimize(
    blueprint: &Blueprint,
    resources: &Resources,
    robots: &Robots,
    minute: i32,
    min_ore_optimization: bool,
) -> Resources {
    if minute == 0 {
        return *resources;
    }

    let mut results = vec![];
    let geode_resources = resources.subtract(&blueprint.geode_robot);
    if geode_resources.valid() {
        let geode_result = optimize(
            blueprint,
            &geode_resources.add(robots),
            &robots.add_robots(&Robots {
                ore_robots: 0,
                clay_robots: 0,
                obsidian_robots: 0,
                geode_robots: 1,
            }),
            minute - 1,
            min_ore_optimization,
        );
        results.push(geode_result);
    }

    let obsidian_resources = resources.subtract(&blueprint.obsidian_robot);
    if obsidian_resources.valid() && !geode_resources.valid() {
        let obsidian_result = optimize(
            blueprint,
            &obsidian_resources.add(robots),
            &robots.add_robots(&Robots {
                ore_robots: 0,
                clay_robots: 0,
                obsidian_robots: 1,
                geode_robots: 0,
            }),
            minute - 1,
            min_ore_optimization,
        );
        results.push(obsidian_result);
    }
    if !geode_resources.valid() && !obsidian_resources.valid() {
        let clay_resources = resources.subtract(&blueprint.clay_robot);
        if clay_resources.valid() {
            let clay_result = optimize(
                blueprint,
                &clay_resources.add(robots),
                &robots.add_robots(&Robots {
                    ore_robots: 0,
                    clay_robots: 1,
                    obsidian_robots: 0,
                    geode_robots: 0,
                }),
                minute - 1,
                min_ore_optimization,
            );
            results.push(clay_result);
        }

        let ore_resources = resources.subtract(&blueprint.ore_robot);
        if ore_resources.valid() {
            let ore_result = optimize(
                blueprint,
                &ore_resources.add(robots),
                &robots.add_robots(&Robots {
                    ore_robots: 1,
                    clay_robots: 0,
                    obsidian_robots: 0,
                    geode_robots: 0,
                }),
                minute - 1,
                min_ore_optimization,
            );
            results.push(ore_result);
        }

        if !min_ore_optimization || resources.ore < 4 {
            let nothing_result = optimize(
                blueprint,
                &resources.add(robots),
                &robots,
                minute - 1,
                min_ore_optimization,
            );
            results.push(nothing_result);
        }
    }
    return results.into_iter().max_by_key(|r| r.geode).unwrap();
}

pub fn parse_blueprint(input: String) -> Blueprint {
    let tokens = input
        .trim()
        .split(" ")
        .map(|t| t.parse::<i32>().unwrap())
        .collect::<Vec<_>>();
    Blueprint {
        id: tokens[0],
        ore_robot: Resources {
            ore: tokens[1],
            clay: 0,
            obsidian: 0,
            geode: 0,
        },
        clay_robot: Resources {
            ore: tokens[2],
            clay: 0,
            obsidian: 0,
            geode: 0,
        },
        obsidian_robot: Resources {
            ore: tokens[3],
            clay: tokens[4],
            obsidian: 0,
            geode: 0,
        },
        geode_robot: Resources {
            ore: tokens[5],
            clay: 0,
            obsidian: tokens[6],
            geode: 0,
        },
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[ignore]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 33);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 1389);
    }
}
