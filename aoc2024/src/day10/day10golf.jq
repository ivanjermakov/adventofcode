def enumerate: . as $a | keys | map(. as $i | $a[.] | {i: $i, v: .});
def dirs: [{i: -1, j: 0}, {i: 0, j: 1}, {i: 1, j: 0}, {i: 0, j: -1}];
def inBounds($p; $g): all($p.i >= 0, $p.i < ($g | length), $p.j >= 0, $p.j < ($g[0] | length));
def traverse($g): . as $pos | dirs | map({i: (.i + $pos.i), j: (.j + $pos.j)}
  | select(inBounds(.; $g) and $g[.i][.j] == $pos.v + 1) | . + {v: $g[.i][.j]})
  | if $pos.v == 9 then [{wps: [$pos]}] elif isempty(.) then [] else
  map(traverse($g) | map(select(.wps | length | . > 0) | {wps: ([$pos] + .wps)})) | flatten(1) end;
. / "\n" | map(select(length | . > 0) | . / "" | map(tonumber)) as $g | $g | enumerate
  | map(.i as $i | .v | enumerate | map(. + {i: $i, j: .i})) | flatten | map(select(.v == 0))
  | map(traverse($g) | length) | add
