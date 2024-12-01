day1a_build:
	mkdir -p build/day1
	nasm -f elf32 src/day1/day1a.asm -o build/day1/day1a.o
	ld -m elf_i386 build/day1/day1a.o -o build/day1/day1a

day1a_run: day1a_build
	strace build/day1/day1a
