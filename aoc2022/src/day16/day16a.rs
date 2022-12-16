use std::collections::{HashMap, HashSet};
use std::fs::read_to_string;

pub struct Valve {
    pub flow: i32,
    pub adjs: Vec<String>,
}

pub fn read_input_example() -> String {
    read_to_string("data/day16/example.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn read_input() -> String {
    read_to_string("data/day16/a.txt")
        .unwrap()
        .trim()
        .to_string()
}

pub fn solve(input: String) -> i32 {
    let g = parse_graph(input);

    traverse(1, "AA", 0, 0, &HashSet::new(), &g, &mut HashMap::new()).unwrap()
}

fn traverse(
    minute: i32,
    valve_name: &str,
    total_flow: i32,
    total_score: i32,
    open_valves: &HashSet<String>,
    valve_map: &HashMap<String, Valve>,
    cache: &mut HashMap<(i32, String, i32), i32>,
) -> Option<i32> {
    if minute > 30 {
        return Some(total_score);
    }

    let cache_key = (minute, valve_name.to_string(), total_flow);
    if let Some(cached_value) = cache.get(&cache_key) {
        if *cached_value >= total_score {
            return None;
        }
    }
    cache.insert(cache_key, total_score);

    let current_valve = valve_map.get(valve_name).unwrap();

    let best_open = if current_valve.flow > 0 && !open_valves.contains(valve_name) {
        let mut new_open_valves = open_valves.iter().cloned().collect::<HashSet<_>>();
        new_open_valves.insert(valve_name.to_string());

        let new_score = total_score + total_flow;
        let new_flow = total_flow + current_valve.flow;
        traverse(
            minute + 1,
            valve_name,
            new_flow,
            new_score,
            &new_open_valves,
            valve_map,
            cache,
        )
    } else {
        None
    };

    let best_skip = current_valve
        .adjs
        .iter()
        .filter_map(|next_valve_name| {
            traverse(
                minute + 1,
                next_valve_name,
                total_flow,
                total_score + total_flow,
                open_valves,
                valve_map,
                cache,
            )
        })
        .max();

    best_skip.max(best_open)
}

pub fn parse_graph(input: String) -> HashMap<String, Valve> {
    let mut nodes = HashMap::new();
    for line in input.split("\n") {
        let tokens = line.split(" -> ").collect::<Vec<&str>>();
        let left = tokens[0].split(" ").collect::<Vec<&str>>();
        let node = left[0];
        let flow = left[1];
        let adjs = tokens[1]
            .split(", ")
            .map(|n| n.to_string())
            .collect::<Vec<String>>();
        nodes.insert(
            node.to_string(),
            Valve {
                flow: flow.parse::<i32>().unwrap(),
                adjs,
            },
        );
    }
    nodes
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 1651);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 0);
    }
}
