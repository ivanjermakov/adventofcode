(ns day3.day3a)

(defn main [_args]
  (let [input (slurp "data/day3.txt")
        gs (re-seq #"mul\((\d{1,3}),(\d{1,3})\)" input)
        map-g (fn [g] (reduce * (map #(Integer/parseInt %) (drop 1 g))))
        res (reduce + (map map-g gs))]
    (println res)))
