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
