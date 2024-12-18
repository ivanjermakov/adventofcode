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

let rec move_ cells pos dir = 
    let at p cs = List.find_opt (fun (p_, _) -> p_ = p) cs in
    let other_cells p = List.filter (fun (p_, _) -> p_ <> p) in
    let update_cell old_pos new_cell cs = (other_cells old_pos cs) @ [new_cell] in
    let left (i, j) = (i, j - 1) in
    let right (i, j) = (i, j + 1) in
    let next_pos (i, j) = match dir with
    | '^' -> (i - 1, j)
    | 'v' -> (i + 1, j)
    | '<' -> (i, j - 1)
    | '>' -> (i, j + 1)
    | _ -> raise Exit in
    match at pos cells with
    | Some cell -> (
        let (_, v) = cell in
        match (v, dir) with
        | ('#', _) -> None
        | ('@', _) | ('[', '<') | ('[', '>') | (']', '<') | (']', '>') -> (
            let npos = next_pos pos in
            match move_ cells npos dir with
            | Some (ncs, _) -> Some (update_cell pos (npos, v) ncs, npos)
            | None -> None
        )
        | (_, '^') | (_, 'v') ->
            let npos1 = next_pos pos in
            match move_ cells npos1 dir with
            | Some (ncs, _) -> (
                let cells = update_cell pos (npos1, v) ncs in
                let (pos2, v2) = match v with
                | '[' -> (right pos, ']')
                | ']' -> (left pos, '[')
                | _ -> assert false in
                let npos2 = next_pos pos2 in
                match move_ cells npos2 dir with
                | Some (ncs, _) -> Some (update_cell pos2 (npos2, v2) ncs, npos2)
                | None -> None
            )
            | None -> None
    )
    | _ -> Some (cells, pos)

let move cells cell dir = match move_ cells cell dir with
    | Some r -> r
    | _ -> (cells, cell)

let range l = List.init l (fun i -> i)

let show_cells cs =
    let size = 50 in
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
    let (cells, (pos, _), dirs) = parse input in
    let res = dirs
    |> Seq.fold_left (fun (cs, ps) d -> move cs ps d) (cells, pos)
    |> fst in
    print_endline (show_cells res);
    res
    |> List.map dist |> List.fold_left (+) 0
    |> Int.to_string |> print_endline
