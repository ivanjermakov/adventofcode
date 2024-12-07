import file_streams/file_stream
import file_streams/text_encoding
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

fn compute(line: String) -> Int {
  let assert [l, r] = line |> string.split(": ")
  let assert Ok(test_value) = l |> int.parse()
  let assert Ok(operands) =
    r |> string.split(" ") |> list.map(int.parse) |> result.all
  case test_equation(test_value, operands, 0) {
    True -> test_value
    False -> 0
  }
}

fn test_equation(test_value: Int, operands: List(Int), acc: Int) -> Bool {
  case operands {
    _ if acc > test_value -> False
    [] -> test_value == acc
    [o, ..rest] ->
      test_equation(test_value, rest, concat(acc, o))
      || test_equation(test_value, rest, acc * o)
      || test_equation(test_value, rest, acc + o)
  }
}

fn concat(a: Int, b: Int) -> Int {
  let assert Ok(res) = int.to_string(a) |> string.append(int.to_string(b)) |> int.parse()
  res
}

pub fn main() {
  use stream <- result.try(
    "../../../data/day7.txt"
    |> file_stream.open_read_text(text_encoding.Unicode),
  )
  use str <- result.try(file_stream.read_chars(stream, 100_000))
  let res =
    str
    |> string.split("\n")
    |> list.filter(fn(l) { !string.is_empty(l) })
    |> list.map(compute)
    |> list.fold(0, int.add)
  res |> int.to_string |> io.println
  Ok(Nil)
}
