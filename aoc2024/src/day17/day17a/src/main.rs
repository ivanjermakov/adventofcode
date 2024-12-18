use regex::Regex;
use std::fs::read_to_string;

#[derive(Debug)]
struct Vm {
    a: u32,
    b: u32,
    c: u32,
    is: Vec<u32>,
    ip: usize,
    out: Vec<u8>,
}

impl Vm {
    fn run(&mut self) {
        while self.ip < self.is.len() {
            self.run_next_inst();
        }
    }

    fn run_next_inst(&mut self) {
        let i = self.is[self.ip];
        let l = self.is[self.ip + 1];
        match i {
            0 => self.adv(l),
            1 => self.bxl(l),
            2 => self.bst(l),
            3 => self.jnz(l),
            4 => self.bxc(),
            5 => self.out(l),
            6 => self.bdv(l),
            7 => self.cdv(l),
            _ => unreachable!("unknown opcode: {}", i),
        }
    }

    fn combo(&self, l: u32) -> u32 {
        match l {
            0..=3 => l,
            4 => self.a,
            5 => self.b,
            6 => self.c,
            _ => unreachable!("unknown combo: {}", l),
        }
    }

    fn adv(&mut self, o: u32) {
        self.a >>= self.combo(o);
        self.ip += 2;
    }

    fn bxl(&mut self, o: u32) {
        self.b ^= o;
        self.ip += 2;
    }

    fn bst(&mut self, o: u32) {
        self.b = self.combo(o) & 7;
        self.ip += 2;
    }

    fn jnz(&mut self, o: u32) {
        if self.a > 0 {
            self.ip = o as usize;
        } else {
            self.ip += 2;
        }
    }

    fn bxc(&mut self) {
        self.b ^= self.c;
        self.ip += 2;
    }

    fn out(&mut self, o: u32) {
        self.out.push((self.combo(o) & 7) as u8);
        self.ip += 2;
    }

    fn bdv(&mut self, o: u32) {
        self.b = self.a >> self.combo(o);
        self.ip += 2;
    }

    fn cdv(&mut self, o: u32) {
        self.c = self.a >> self.combo(o);
        self.ip += 2;
    }

    fn output(&self) -> String {
        self.out
            .iter()
            .map(ToString::to_string)
            .collect::<Vec<_>>()
            .join(",")
    }
}

impl From<&str> for Vm {
    fn from(input: &str) -> Self {
        let re = Regex::new(r"\d+").unwrap();
        let mut ns = re
            .find_iter(input)
            .filter_map(|mat| mat.as_str().parse::<u32>().ok());
        Self {
            a: ns.next().unwrap(),
            b: ns.next().unwrap(),
            c: ns.next().unwrap(),
            is: ns.collect::<Vec<_>>(),
            ip: 0,
            out: vec![],
        }
    }
}

fn main() {
    let input = read_to_string("data/day17.txt").unwrap();
    let mut vm: Vm = input.as_str().into();
    vm.run();
    println!("{}", vm.output());
}
