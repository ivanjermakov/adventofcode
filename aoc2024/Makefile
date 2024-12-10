day1a_build:
	mkdir -p build/day1
	nasm -g -f elf64 src/day1/day1a.asm -o build/day1/day1a.o
	ld build/day1/day1a.o -o build/day1/day1a

day1a_run: day1a_build
	build/day1/day1a | od -An -tu4 | tr -d ' '

day1b_build:
	mkdir -p build/day1
	nasm -g -f elf64 src/day1/day1b.asm -o build/day1/day1b.o
	ld build/day1/day1b.o -o build/day1/day1b

day1b_run: day1b_build
	build/day1/day1b | od -An -tu4 | tr -d ' '

day2a_run:
	bqn -f src/day2/day2a.bqn

day2b_run:
	bqn -f src/day2/day2b.bqn

day3a_run:
	clj -X day3.day3a/main

day3b_run:
	clj -X day3.day3b/main

day4a_build:
	mkdir -p build/day4
	dmd -of=build/day4/day4a src/day4/day4a.d

day4a_run: day4a_build
	build/day4/day4a

day4b_build:
	mkdir -p build/day4
	dmd -of=build/day4/day4b src/day4/day4b.d

day4b_run: day4b_build
	build/day4/day4b

day5a_build:
	mkdir -p build/day5
	erlc -o build/day5/ src/day5/day5a.erl

day5a_run: day5a_build
	erl -pa build/day5 -noshell -s day5a main

day5b_build:
	mkdir -p build/day5
	erlc -o build/day5/ src/day5/day5b.erl

day5b_run: day5b_build
	erl -pa build/day5 -noshell -s day5b main

day6a_build:
	mkdir -p build/day6
	gcc -O3 src/day6/day6a.c -o build/day6/day6a

day6a_run: day6a_build
	build/day6/day6a

day6b_build:
	mkdir -p build/day6
	gcc -O3 src/day6/day6b.c -o build/day6/day6b

day6b_run: day6b_build
	build/day6/day6b

day7a_run:
	cd src/day7/day7a && gleam run

day7b_run:
	cd src/day7/day7b && gleam run

day8a_build:
	mkdir -p build/day8
	ghc -o build/day8/day8a -outputdir build/day8 src/day8/day8a.hs

day8a_run: day8a_build
	build/day8/day8a

day8b_build:
	mkdir -p build/day8
	ghc -o build/day8/day8b -outputdir build/day8 src/day8/day8b.hs

day8b_run: day8b_build
	build/day8/day8b

day9a_build:
	go build -o build/day9/day9a src/day9/day9a.go

day9a_run: day9a_build
	build/day9/day9a

day9b_build:
	go build -o build/day9/day9b src/day9/day9b.go

day9b_run: day9b_build
	build/day9/day9b

day10a_run:
	cat data/day10.txt | jq -Rs -f src/day10/day10a.jq

day10b_run:
	cat data/day10.txt | jq -Rs -f src/day10/day10b.jq
