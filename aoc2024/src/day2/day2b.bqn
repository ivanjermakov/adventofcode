SplitBy ← {𝕨((⊢-˜¬×+`)∘=⊔⊢)𝕩}
Permute ← {
    ls ← 𝕩
    l ← ≠ls
    dropIxs ← ↕l
    perms ← {⊏𝕩⊔ls}˘{𝕩=˘dropIxs}˘dropIxs
    ls <⊸∾ perms
}
Test ← {
    diffs ← -´˘2↕𝕩
    gz ← ×´0<¨diffs
    lz ← ×´0>¨diffs
    l3 ← ×´3≥|¨diffs
    (gz+lz)×l3
}
•Show +´0<¨+´¨Test¨¨Permute¨•ParseFloat¨¨' 'SplitBy¨•FLines"../../data/day2.txt"
