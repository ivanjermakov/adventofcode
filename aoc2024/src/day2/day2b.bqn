SplitBy ← {𝕨((⊢-˜¬×+`)∘=⊔⊢)𝕩}
Permute ← {
    ls ← 𝕩
    r ← ↕≠ls
    ls <⊸∾ ({⊏𝕩⊔ls}{𝕩=˘r})˘r
}
Test ← {
    ds ← -´˘2↕𝕩
    gz ← ×´0<¨ds
    lz ← ×´0>¨ds
    l3 ← ×´3≥|¨ds
    (gz+lz)×l3
}
•Show+´0<(+´0<+´Test¨Permute)¨•ParseFloat¨¨' 'SplitBy¨•FLines"../../data/day2.txt"
