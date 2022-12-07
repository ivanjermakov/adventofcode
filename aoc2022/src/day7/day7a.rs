use std::fs::read_to_string;

use crate::day7::day7a::Item::{Directory, File};

#[derive(Debug, PartialEq, Clone)]
pub enum Command {
    Cd(String),
    Ls(Vec<Item>),
}

#[derive(Debug, PartialEq, Clone)]
pub enum Item {
    File(String, u32),
    Directory(String, Vec<Item>),
}

impl Item {
    pub fn name(&self) -> String {
        match self {
            File(n, _) => n.clone(),
            Directory(n, _) => n.clone(),
        }
    }
}

pub fn read_input() -> String {
    read_to_string("data/day7/a.txt").unwrap()
}

pub fn parse_commands(input: String) -> Vec<Command> {
    input
        .trim()
        .split("$ ")
        .filter(|c| !c.is_empty())
        .map(|c| {
            let lines: Vec<&str> = c.split("\n").filter(|l| !l.is_empty()).collect();
            parse_command(
                lines[0].to_string(),
                lines[1..]
                    .iter()
                    .map(|s| parse_file(s.to_string()))
                    .collect(),
            )
        })
        .collect()
}

pub fn parse_command(input: String, files: Vec<Item>) -> Command {
    let tokens: Vec<&str> = input.split(" ").collect();

    match tokens[0] {
        "cd" => Command::Cd(tokens[1].to_string()),
        "ls" => Command::Ls(files),
        _ => unreachable!(),
    }
}

pub fn parse_file(input: String) -> Item {
    let tokens: Vec<&str> = input.split(" ").collect();
    let name = tokens[1].to_string();

    match tokens[0] {
        "dir" => Directory(name, vec![]),
        t => Item::File(name, t.parse::<u32>().unwrap()),
    }
}

pub fn parse_tree(commands: Vec<Command>) -> Item {
    let mut root = Directory("/".to_string(), vec![]);

    let mut pwd: Vec<String> = vec![];
    for command in commands {
        match command {
            Command::Cd(dir) => {
                if dir == "/" {
                    continue;
                }
                if dir == ".." {
                    pwd.pop();
                    continue;
                }
                pwd.push(dir);
                add_dir(&mut root, &pwd);
            }
            Command::Ls(files) => {
                add_files(&mut root, &pwd, &files);
            }
        }
    }

    root
}

fn add_files(root: &mut Item, path: &Vec<String>, files: &Vec<Item>) {
    if let Directory(.., d_files) = cd(root, path) {
        d_files.extend(files.clone());
    }
}

fn add_dir(root: &mut Item, path: &Vec<String>) {
    let name = path[path.len() - 1].clone();
    if let Directory(.., d_files) = cd(root, &path[..path.len() - 1].to_vec()) {
        if d_files.iter().find(|f| f.name() == name).is_none() {
            d_files.push(Directory(name, vec![]));
        }
    }
}

fn flatten_dirs<'a>(root: &'a Item) -> Vec<&'a Item> {
    if let Directory(_, files) = root {
        let mut res = vec![root];
        for file in files {
            res.extend(flatten_dirs(file))
        }
        res
    } else {
        vec![]
    }
}

fn get_size(dir: &Item) -> u32 {
    match dir {
        Directory(_, files) => files.iter().map(|file| get_size(file)).sum::<u32>(),
        File(_, size) => *size,
    }
}

fn cd<'a>(root: &'a mut Item, path: &Vec<String>) -> &'a mut Item {
    if path.is_empty() {
        return root;
    }
    if let Directory(.., files) = root {
        let dir = files
            .iter_mut()
            .find(|f| f.name() == path[0])
            .expect(format!("no dir named {}", path[0]).as_str());
        return cd(dir, &path[1..].to_vec());
    }
    panic!("not a directory")
}

pub fn solve(_input: String) -> u32 {
    let input = read_input();
    let commands = parse_commands(input);
    let tree = parse_tree(commands);
    flatten_dirs(&tree)
        .iter()
        .map(|dir| get_size(dir))
        .filter(|size| *size <= 100_000)
        .sum()
}

#[cfg(test)]
mod tests {
    use crate::day7::day7a::Item::File;

    use super::*;

    fn example_tree() -> Item {
        Directory(
            "/".to_string(),
            vec![
                Directory(
                    "a".to_string(),
                    vec![
                        Directory("e".to_string(), vec![File("i".to_string(), 584)]),
                        File("f".to_string(), 29116),
                        File("g".to_string(), 2557),
                        File("h.lst".to_string(), 62596),
                    ],
                ),
                File("b.txt".to_string(), 14848514),
                File("c.dat".to_string(), 8504156),
                Directory(
                    "d".to_string(),
                    vec![
                        File("j".to_string(), 4060174),
                        File("d.log".to_string(), 8033020),
                        File("d.ext".to_string(), 5626152),
                        File("k".to_string(), 7214296),
                    ],
                ),
            ],
        )
    }

    #[test]
    fn should_parse_commands() {
        let result = parse_commands(
            "$ cd /\n$ ls\ndir bhtvbj\ndir bmlllrl\n$ ls\n232616 ngmqbc.mdj\n75367 vqqcvgts.vrc\n"
                .to_string(),
        );
        assert_eq!(
            result,
            vec![
                Command::Cd("/".to_string()),
                Command::Ls(vec![
                    Directory("bhtvbj".to_string(), vec![]),
                    Directory("bmlllrl".to_string(), vec![])
                ]),
                Command::Ls(vec![
                    File("ngmqbc.mdj".to_string(), 232616),
                    File("vqqcvgts.vrc".to_string(), 75367)
                ]),
            ]
        );
    }

    #[test]
    fn should_parse_tree() {
        let input = read_to_string("data/day7/example.txt");
        let tree = parse_tree(parse_commands(input.unwrap()));
        assert_eq!(tree, example_tree())
    }

    #[test]
    fn should_get_size() {
        assert_eq!(get_size(&example_tree()), 48381165)
    }

    #[test]
    fn should_solve() {
        let input = read_input();
        let result = solve(input);
        assert_eq!(result, 1477771);
    }
}
