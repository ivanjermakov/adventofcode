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
	gcc src/day6/day6a.c -o build/day6/day6a

day6a_run: day6a_build
	build/day6/day6a
