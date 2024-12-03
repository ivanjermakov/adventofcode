(ns day3.day3b)

(require '[clojure.string :as str])

(defn main [_args]
  (let [input (str/join
               ""
               (re-seq #"(?s)do\(\).*?don't\(\)"
                       (str "do()" (slurp "data/day3.txt") "don't()")))
        gs (re-seq #"mul\((\d{1,3}),(\d{1,3})\)" input)
        map-g (fn [g] (reduce * (map #(Integer/parseInt %) (drop 1 g))))
        res (reduce + (map map-g gs))]
    (println res)))
