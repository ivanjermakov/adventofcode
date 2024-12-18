use regex::Regex;
use std::fs::read_to_string;

#[derive(Debug, Clone)]
struct Vm {
    a: u64,
    b: u64,
    c: u64,
    is: Vec<u8>,
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

    fn combo(&self, l: u8) -> u64 {
        match l {
            0..=3 => l as u64,
            4 => self.a,
            5 => self.b,
            6 => self.c,
            _ => unreachable!("unknown combo: {}", l),
        }
    }

    fn adv(&mut self, o: u8) {
        self.a >>= self.combo(o);
        self.ip += 2;
    }

    fn bxl(&mut self, o: u8) {
        self.b ^= o as u64;
        self.ip += 2;
    }

    fn bst(&mut self, o: u8) {
        self.b = self.combo(o) & 7;
        self.ip += 2;
    }

    fn jnz(&mut self, o: u8) {
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

    fn out(&mut self, o: u8) {
        self.out.push((self.combo(o) & 7) as u8);
        self.ip += 2;
    }

    fn bdv(&mut self, o: u8) {
        self.b = self.a >> self.combo(o);
        self.ip += 2;
    }

    fn cdv(&mut self, o: u8) {
        self.c = self.a >> self.combo(o);
        self.ip += 2;
    }
}

impl From<&str> for Vm {
    fn from(input: &str) -> Self {
        let re = Regex::new(r"\d+").unwrap();
        let mut ns = re
            .find_iter(input)
            .filter_map(|mat| mat.as_str().parse::<u64>().ok());
        Self {
            a: ns.next().unwrap(),
            b: ns.next().unwrap(),
            c: ns.next().unwrap(),
            is: ns.map(|n| n as u8).collect::<Vec<_>>(),
            ip: 0,
            out: vec![],
        }
    }
}

/// Start with `start = 0` and step `1 << 20`, wait for eq output length and out ending on 1 common value.
/// Set start to that, reduce step by one power, refine search to one more common ending value.
/// Iterate until `target_out == out`.
fn main() {
    let input = read_to_string("data/day17.txt").unwrap();
    let vm_snap: Vm = input.as_str().into();
    let target_out = vm_snap.is.iter().collect::<Vec<_>>();
    let start = 267265166221824;
    let step = 1;
    for i in 0.. {
        let mut vm = vm_snap.clone();
        let a = start + i * step;
        vm.a = a;
        vm.run();

        let out = vm.out.iter().collect::<Vec<_>>();
        if out.len() == target_out.len() && out.ends_with(&target_out[target_out.len() - 16..]) {
            // println!("{:?} {:?} {:?}", a, out, target_out);
            // break;
        }
        if out == target_out {
            println!("{a}");
            break;
        }
    }
}
