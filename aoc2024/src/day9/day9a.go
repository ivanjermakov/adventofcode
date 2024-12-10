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
	for i <= j {
		if i == j && files[i - 1].Index == files[i].Index {
			files[i - 1].Value = files[i - 1].Value + files[i].Value
			j--
			continue
		}
		if files[i].Index >= 0 {
			i++
		} else {
			var last = files[j]
			if last.Index < 0 {
				j--
				continue
			}
			var moveSize = min(files[i].Value, last.Value)
			var keepSize = last.Value - moveSize
			var spaceLeft = files[i].Value - moveSize
			if keepSize == 0 && spaceLeft == 0 {
				// perfect fit
				files[i].Index = last.Index
				files[i].Value = moveSize
				// fmt.Println("perfect", files)
				i++
				j--
			} else if keepSize > 0 {
				// did not fit into free sector
				files[i].Index = last.Index
				files[i].Value = moveSize
				files[j].Value = keepSize
				// fmt.Println("partial move", files)
				i++
			} else if spaceLeft > 0 {
				// some space left free
				files[i].Value = spaceLeft
				slices.Insert(files, i, last)
				// fmt.Println("left space", files)
				i++
			} else {
				log.Fatalf("unreachable")
			}
		}
	}
	return files[:i]
}

func Checksum(files []File) int {
	var res = 0
	var j = 0
	for _, f := range files {
		res = res + ((f.Value * (j + j + f.Value - 1) / 2)) * f.Index
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
