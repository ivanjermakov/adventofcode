package main

import "fmt"
import "io/ioutil"
import "strconv"
import "strings"
import "slices"
import "log"

type File struct {
	Index int
	Value int
}

func ParseInput(input string) []int {
	var digits []int
	for _, char := range input {
		digit, _ := strconv.Atoi(string(char))
		digits = append(digits, digit)
	}
	return digits
}

func EnumerateFiles(ns []int) []File {
	var res []File
	for i, n := range ns {
		if i % 2 == 0 {
			res = append(res, File{i / 2, n})
		} else {
			if n > 0 {
				res = append(res, File{-1, n})
			}
		}
	}
	return res
}

func Defragment(files []File) []File {
	var i = 0
	var j = len(files) - 1
	for j > 0 {
		if j <= i {
			// no place to move, skipping
			j--
			i = 0
		} else if files[i].Index >= 0 {
			i++
		} else {
			if files[j].Index < 0 {
				j--
				continue
			}
			var avail = files[i].Value
			var move = files[j].Value
			if avail < move {
				// did not fit into free sector
				i++
			} else if avail == move {
				// perfect fit
				files[i].Index = files[j].Index
				files[j].Index = -1
				j--
				i = 0
			} else if avail > move {
				var left = avail - move
				// some space left free
				files[i].Value = left
				var idx = files[j].Index
				files[j].Index = -1
				files = slices.Insert(files, i, File{idx, move})
				// no decrement since insert is offsetting the rest of files
				// j--
				i = 0
			} else {
				log.Fatalf("unreachable")
			}
		}
	}
	return files
}

func Checksum(files []File) int {
	var res = 0
	var j = 0
	for _, f := range files {
		if f.Index >= 0 {
			res = res + ((f.Value * (j + j + f.Value - 1) / 2)) * f.Index
		}
		j = j + f.Value
	}
	return res
}

func main() {
	inputB, _ := ioutil.ReadFile("data/day9.txt")
	inputStr := strings.TrimRight(string(inputB), "\n")
	input := ParseInput(inputStr)
	files := EnumerateFiles(input)
	defrFiles := Defragment(files)
	checksum := Checksum(defrFiles)
	fmt.Println(checksum)
}

