def tr($i;$j;$g;$v):[{i:-1},{j:1},{i:1},{j:-1}]|map({i:0,j:0
}+.)|map({i:(.i+$i),j:(.j+$j)}|$g[.i][.j]as$n|select(.i>=0
and.j>=0and$n==$v+1)|if$n==9then 1else tr(.i;.j;$g;$n)end)|
add;./"\n"|map(./""|select(length|.>0)|map(tonumber))|. as
$g|keys|map(. as$i|$g[.]|keys|map(. as$j|select($g[$i][$j]==
0)|tr($i;$j;$g;0)))|flatten(1)|add

