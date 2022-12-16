use crate::day16::day16a::{parse_graph, Valve};
use std::collections::{HashMap, HashSet};

pub fn solve(input: String) -> i32 {
    let g = parse_graph(input);

    traverse(
        1,
        "AA",
        "AA",
        0,
        0,
        &HashSet::new(),
        &g,
        &mut HashMap::new(),
    )
    .unwrap()
}

fn traverse(
    minute: i32,
    my_valve_name: &str,
    el_valve_name: &str,
    total_flow: i32,
    total_score: i32,
    open_valves: &HashSet<String>,
    valve_map: &HashMap<String, Valve>,
    cache: &mut HashMap<(i32, String, String, i32), i32>,
) -> Option<i32> {
    if minute > 26 {
        return Some(total_score);
    }

    let cache_key = (
        minute,
        my_valve_name.to_string(),
        el_valve_name.to_string(),
        total_flow,
    );
    if let Some(cached_value) = cache.get(&cache_key) {
        if *cached_value >= total_score {
            return None;
        }
    }
    cache.insert(cache_key, total_score);

    let (my_flow, my_tunnels) = {
        let valve = valve_map.get(my_valve_name).unwrap();
        (valve.flow, valve.adjs.to_vec())
    };
    let (elephant_flow, elephant_tunnels) = {
        let valve = valve_map.get(el_valve_name).unwrap();
        (valve.flow, valve.adjs.to_vec())
    };

    let can_open_my_valve = my_flow > 0 && !open_valves.contains(my_valve_name);
    let can_open_elephant_valve = elephant_flow > 0 && !open_valves.contains(el_valve_name);
    let mut results = Vec::new();

    if can_open_my_valve {
        let mut new_open_valves = open_valves.iter().cloned().collect::<HashSet<_>>();
        new_open_valves.insert(my_valve_name.to_string());

        for new_el_valve_name in elephant_tunnels.iter() {
            results.push(traverse(
                minute + 1,
                my_valve_name,
                new_el_valve_name,
                total_flow + my_flow,
                total_score + total_flow,
                &new_open_valves,
                valve_map,
                cache,
            ));
        }
    }

    if can_open_elephant_valve {
        let mut new_open_valves = open_valves.iter().cloned().collect::<HashSet<_>>();
        new_open_valves.insert(el_valve_name.to_string());

        for new_my_valve_name in my_tunnels.iter() {
            results.push(traverse(
                minute + 1,
                new_my_valve_name,
                el_valve_name,
                total_flow + elephant_flow,
                total_score + total_flow,
                &new_open_valves,
                valve_map,
                cache,
            ));
        }
    }

    if can_open_elephant_valve && can_open_my_valve && my_valve_name != el_valve_name {
        let mut new_open_valves = open_valves.iter().cloned().collect::<HashSet<_>>();
        new_open_valves.insert(el_valve_name.to_string());
        new_open_valves.insert(my_valve_name.to_string());

        results.push(traverse(
            minute + 1,
            my_valve_name,
            el_valve_name,
            total_flow + my_flow + elephant_flow,
            total_score + total_flow,
            &new_open_valves,
            valve_map,
            cache,
        ));
    }

    for new_el_valve_name in elephant_tunnels.iter() {
        for new_my_valve_name in my_tunnels.iter() {
            results.push(traverse(
                minute + 1,
                new_my_valve_name,
                new_el_valve_name,
                total_flow,
                total_score + total_flow,
                open_valves,
                valve_map,
                cache,
            ));
        }
    }

    results.into_iter().flatten().max()
}

#[cfg(test)]
mod tests {
    use crate::day16::day16a::{read_input, read_input_example};

    use super::*;

    #[test]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 1707);
    }

    #[ignore]
    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 2464);
    }
}
