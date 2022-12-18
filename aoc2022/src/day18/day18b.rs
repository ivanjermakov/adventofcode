use crate::day18::day18a::{get_sides, parse_coords, Vec3};
use std::collections::HashSet;

pub fn solve(input: String) -> i32 {
    let coords = &parse_coords(input);
    let mut total: i32 = 0;
    let bounds = coords
        .iter()
        .fold(Vec3 { x: 0, y: 0, z: 0 }, |acc, p| Vec3 {
            x: acc.x.max(p.x),
            y: acc.y.max(p.y),
            z: acc.z.max(p.z),
        });
    let mut air_ps = HashSet::new();
    for c in coords {
        let sides = get_sides();
        let free = sides
            .iter()
            .map(|s| {
                let t = Vec3 {
                    x: c.x + s.x,
                    y: c.y + s.y,
                    z: c.z + s.z,
                };
                if !air_ps.contains(&t) {
                    let flood =
                        flood_fill(&t, coords, &bounds, &HashSet::new()).unwrap_or(HashSet::new());
                    air_ps.extend(flood);
                }
                coords.contains(&t) || air_ps.contains(&t)
            })
            .filter(|b| !*b)
            .count();
        total += free as i32;
    }
    total
}

pub fn flood_fill(
    p: &Vec3,
    coords: &HashSet<Vec3>,
    bounds: &Vec3,
    f_air: &HashSet<Vec3>,
) -> Option<HashSet<Vec3>> {
    if p.x < 0 || p.x > bounds.x || p.y < 0 || p.y > bounds.y || p.z < 0 || p.z > bounds.z {
        return None;
    }
    if f_air.contains(p) || coords.contains(p) {
        return Some(HashSet::new());
    }
    let mut air = f_air.clone();
    air.insert(p.clone());
    for s in get_sides() {
        let n = Vec3 {
            x: p.x + s.x,
            y: p.y + s.y,
            z: p.z + s.z,
        };
        let fill = flood_fill(&n, coords, bounds, &air);
        if let Some(f) = fill {
            air.extend(f)
        } else {
            return None;
        }
    }
    Some(air)
}

#[cfg(test)]
mod tests {
    use crate::day18::day18a::{read_input, read_input_example};

    use super::*;

    #[test]
    #[ignore]
    fn should_solve_example() {
        let input = read_input_example();
        let result = solve(input);
        assert_eq!(result, 58);
    }

    #[test]
    #[ignore]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 2530);
    }
}
