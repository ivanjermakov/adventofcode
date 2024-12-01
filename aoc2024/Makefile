day1a_build:
	mkdir -p build/day1
	nasm -g -f elf64 src/day1/day1a.asm -o build/day1/day1a.o
	ld build/day1/day1a.o -o build/day1/day1a

day1a_run: day1a_build
	build/day1/day1a | od -An -tu4 | tr -d ' '
