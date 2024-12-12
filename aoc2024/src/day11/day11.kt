import java.io.File
import java.util.*

fun main() {
    val ns = File("data/day11.txt").readLines()[0].split(" ").map({ it.toLong() })
    val blinks = 25
    var map = ns.associateBy({ it }, { 1L }).toMutableMap()
    for (i in 1..blinks) {
        val nmap = mutableMapOf<Long, Long>()
        for ((key, value) in map) {
            when {
                key == 0L -> nmap.merge(1L, value, { a, b -> a + b })
                (key.toString().length % 2) == 0 -> {
                    val s = key.toString()
                    nmap.merge(s.substring(0..<s.length / 2).toLong(), value, { a, b -> a + b })
                    nmap.merge(s.substring(s.length / 2 ..<s.length).toLong(), value, { a, b -> a + b })
                }
                else -> nmap.merge(key * 2024L, value, { a, b -> a + b })
            }
        }
        map = nmap
    }
    println(map.values.fold(0L, { a, b -> a + b }))
}
