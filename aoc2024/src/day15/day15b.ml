exception Todo

let all_some lst =
    List.fold_right (fun elem acc ->
        match elem, acc with
        | None, _ -> None
        | _, None -> None
        | Some x, Some xs -> Some (x :: xs)
    ) lst (Some [])

let read_file filename = filename |> open_in |> In_channel.input_all

let parse input = match Str.split (Str.regexp_string "\n\n") input with
    | g :: dirs :: _ ->
        let ps = (String.split_on_char '\n' g)
            |> List.mapi (
                fun i row -> row
                    |> String.to_seq
                    |> List.of_seq
                    |> List.mapi (fun j v ->
                        match v with
                        | 'O' -> [((i, j * 2), '['); ((i, j * 2 + 1), ']')]
                        | '#' -> [((i, j * 2), v); ((i, j * 2 + 1), v)]
                        | _ -> [((i, j * 2), v)]
                    )
                    |> List.concat
            )
            |> List.concat in
        (
            List.filter (fun (_, v) -> v != '.') ps,
            List.find (fun (_, v) -> v = '@') ps,
            dirs |> String.to_seq |> Seq.filter (fun c -> c != '\n')
        )
    | _ -> assert false

let rec move_ cells cell dir = 
    Some (cells, cell)

let move cells cell dir = match move_ cells cell dir with
    | Some r -> r
    | _ -> (cells, cell)

let range l = List.init l (fun i -> i)

let show_cells cs =
    let size = 7 in
    let show_cell i j = match cs |> List.find_opt (fun ((ci, cj), _) -> ci = i && cj = j) with
    | Some (_, c) -> c
    | _ -> '.' in
    let join chs = chs |> List.map (String.make 1) in
    range size
    |> List.map (fun i -> range (size * 2) |> List.map (fun j -> show_cell i j) |> join)
    |> List.map (fun s -> s |> String.concat "")
    |> String.concat "\n"

let dist ((i, j), v) = match v with
| '[' -> 100 * i + j
| _ -> 0

let solve =
    let input = read_file "data/day15.txt" in
    let (cells, cell, dirs) = parse input in
    let res = dirs
    |> Seq.take 1
    |> Seq.fold_left (fun (cs, ps) d -> move cs ps d) (cells, cell)
    |> fst in
    print_endline (show_cells res);
    (* res *)
    (* |> List.map dist |> List.fold_left (+) 0 *)
    (* |> Int.to_string |> print_endline *)
