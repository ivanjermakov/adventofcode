def enumerate:
  . as $a | keys | map(. as $i | $a[.] | {i: $i, v: .})
;

def dirs: [
  {i: -1, j:  0},
  {i:  0, j:  1},
  {i:  1, j:  0},
  {i:  0, j: -1}
]
;

def traverse($pos; $grid):
  $pos
    | dirs
    | map(
      {i: (.i + $pos.i), j: (.j + $pos.j)}
        | . as $p
        | select(
          all(
            $p.i >= 0,
            $p.i < ($grid | length),
            $p.j >= 0,
            $p.j < ($grid[0] | length),
            $grid[$p.i][$p.j] == $pos.v + 1
          )
        )
        | {i: $p.i, j: $p.j, v: $grid[$p.i][$p.j]}
    )
  as $neighs |
  if $pos.v == 9 then
    [{wps: [$pos]}]
  elif isempty($neighs) then
    []
  else
    $neighs
      | map(traverse(.; $grid) | map(select(.wps | length | . > 0) | {wps: ([$pos] + .wps)}))
      | flatten(1)
  end |
  .
;

.
as $input |

$input / "\n"
  | map(
    select(length | . > 0) | . / ""
    | map(tonumber))
as $grid |

$grid
  | enumerate
  | map(.i as $i | .v | enumerate | map({i: $i, j: .i, v: .v}))
as $locs |

$locs | flatten | map(select(.v == 0))
as $heads |

$heads
  | map(
    traverse(.; $grid)
    | map({start: .wps[0], end: .wps[-1]})
    | unique
    | length
  )
  | add
