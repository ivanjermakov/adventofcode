.PHONY: build
CCFLAGS = -g0

build:
	mkdir -p build
	clang $(CCFLAGS) src/aoc.c -o build/aoc

run: build
	build/aoc
