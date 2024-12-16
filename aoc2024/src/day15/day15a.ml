let read_file filename = filename |> open_in |> In_channel.input_all

let parse input = match Str.split (Str.regexp_string "\n\n") input with
    | g :: dirs :: _ ->
        let ps = (String.split_on_char '\n' g)
            |> List.mapi (
                fun i row -> row
                    |> String.to_seq
                    |> List.of_seq
                    |> List.mapi (fun j v -> ((i, j), v))
            )
            |> List.concat in
        let (p, _) = ps |> List.find (fun (_, v) -> v = '@') in
        (
            List.filter (fun (_, v) -> v != '.') ps,
            p,
            dirs |> String.to_seq |> Seq.filter (fun c -> c != '\n')
        )
    | _ -> raise Exit

let rec move_ cells pos dir = 
    let (i, j) = pos in
    let (_, v) = List.find (fun (p, _) -> p = pos) cells in
    let npos = match dir with
        | '^' -> (i - 1, j)
        | 'v' -> (i + 1, j)
        | '<' -> (i, j - 1)
        | '>' -> (i, j + 1)
        | _ -> raise Exit in
    let (ni, nj) = npos in
    let ncell = List.find_opt (fun (p, _) -> p = npos) cells in
    let other_cells p = List.filter (fun (p_, _) -> p_ <> p) in
    match ncell with
    | Some (_, 'O') -> (
        match move_ cells npos dir with
        | Some (cs, _) -> Some ((other_cells pos cs) @ [(npos, v)], npos)
        | _ -> None
    )
    | Some (_, '#') -> None
    | _ -> Some ((other_cells pos cells) @ [(npos, v)], npos)

let move cells pos dir = match move_ cells pos dir with
    | Some r -> r
    | _ -> (cells, pos)

let range l = List.init l (fun i -> i)

let show_cells cs =
    let size = 50 in
    let show_cell i j = match cs |> List.find_opt (fun ((ci, cj), _) -> ci = i && cj = j) with
    | Some (_, c) -> c
    | _ -> '.' in
    let join chs = chs |> List.map (String.make 1) in
    range size
    |> List.map (fun i -> range size |> List.map (fun j -> show_cell i j) |> join)
    |> List.map (fun s -> s |> String.concat "")
    |> String.concat "\n"

let dist ((i, j), v) = match v with
| 'O' -> 100 * i + j
| _ -> 0

let solve =
    let input = read_file "data/day15.txt" in
    let (cells, pos, dirs) = parse input in
    let res = dirs
    |> Seq.fold_left (fun (cs, ps) d -> move cs ps d) (cells, pos)
    |> fst in
    print_endline (show_cells res);
    res
    |> List.map dist |> List.fold_left (+) 0
    |> Int.to_string |> print_endline
