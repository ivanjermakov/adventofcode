SplitBy ← {𝕨((⊢-˜¬×+`)∘=⊔⊢)𝕩}
Test ← {
    diffs ← -´˘2↕𝕩
    gz ← ×´0<¨diffs
    lz ← ×´0>¨diffs
    l3 ← ×´3≥|¨diffs
    (gz+lz)×l3
}
•Show +´Test¨•ParseFloat¨¨' 'SplitBy¨•FLines "../../data/day2.txt"
