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
                    |> List.mapi (fun j v -> ((i, j * 2), v))
            )
            |> List.concat in
        let (p, _) = ps |> List.find (fun (_, v) -> v = '@') in
        (
            List.filter (fun (_, v) -> v != '.') ps,
            p,
            dirs |> String.to_seq |> Seq.filter (fun c -> c != '\n')
        )
    | _ -> assert false

let rec move_ cells pos dir = 
    let at p = List.find_opt (fun (p, _) -> p = pos) in
    let (_, v) = match at pos cells with | Some c -> c | _ -> assert false in
    let npos = let (i, j) = pos in
    match dir with
        | '^' -> (i - 1, j)
        | 'v' -> (i + 1, j)
        | '<' -> (i, j - 1)
        | '>' -> (i, j + 1)
        | _ -> assert false in
    let other_cells p = List.filter (fun (p_, _) -> p_ <> p) in
    let left (i, j) = (i, j - 1) in
    let right (i, j) = (i, j + 1) in
    let collider_origins = match (dir, v) with
        | ('>', '@') -> [npos; right npos]
        | ('<', '@') -> [npos; left npos]
        | (_, '@') -> [npos; left npos]
        | ('>', 'O') -> [right npos]
        | ('<', 'O') -> [left npos]
        | (_, 'O') -> [npos; left npos; right npos]
        | _ -> assert false in
    let colliders = collider_origins
        |> List.map (fun c -> at c cells)
        |> all_some
    in
    match colliders with
    | Some cs -> raise Todo
    | _ -> Some ((other_cells pos cells) @ [(npos, v)], npos)

let move cells pos dir = match move_ cells pos dir with
    | Some r -> r
    | _ -> (cells, pos)

let range l = List.init l (fun i -> i)

let show_cells cs =
    let size = 7 in
    let at i j = List.find_opt (fun ((ci, cj), _) -> ci = i && cj = j) in
    let show_cell i j = match (cs |> at i j, cs |> at i (j - 1)) with
    | (Some (_, '@'), _) -> '@'
    | (Some (_, 'O'), _) -> '['
    | (_, Some (_, 'O')) -> ']'
    | (Some (_, '#'), _) | (_, Some (_, '#')) -> '#'
    | _ -> '.' in
    let join chs = chs |> List.map (String.make 1) in
    range size
    |> List.map (fun i -> range (size * 2) |> List.map (fun j -> show_cell i j) |> join)
    |> List.map (fun s -> s |> String.concat "")
    |> String.concat "\n"

let dist ((i, j), v) = match v with
| 'O' -> 100 * i + j
| _ -> 0

let solve =
    let input = read_file "data/day15.txt" in
    let (cells, pos, dirs) = parse input in
    let res = dirs
    |> Seq.take 1
    |> Seq.fold_left (fun (cs, ps) d -> move cs ps d) (cells, pos)
    |> fst in
    print_endline (show_cells res);
    (* res *)
    (* |> List.map dist |> List.fold_left (+) 0 *)
    (* |> Int.to_string |> print_endline *)
