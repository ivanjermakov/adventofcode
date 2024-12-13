import java.nio.file.*;
import java.util.*;
import java.util.regex.*;

public class Day13a {
    public static void main(String[] args) throws Exception {
        var input = Files.readString(Paths.get("data/day13.txt"));
        var res = Arrays.stream(input.split("\n\n")).mapToInt(Day13a::solve).sum();
        System.out.println(res);
    }

    static int solve(String group) {
        var matcher = Pattern.compile("\\d+").matcher(group);
        var matches = matcher.results().map(MatchResult::group).map(Integer::parseInt).toList();
        var i = 0;
        var ax = matches.get(i++);
        var ay = matches.get(i++);
        var bx = matches.get(i++);
        var by = matches.get(i++);
        var x = matches.get(i++);
        var y = matches.get(i++);
        var min = Integer.MAX_VALUE;

        var maxCount = 100;
        for (var ac = 0; ac <= maxCount; ac++) {
            for (var bc = 0; bc <= maxCount; bc++) {
                var rx = ac * ax + bc * bx;
                if (rx != x) continue;
                var ry = ac * ay + bc * by;
                if (ry != y) continue;
                var ts = ac * 3 + bc;
                if (ts < min) min = ts;
            }
        }

        return min == Integer.MAX_VALUE ? 0 : min;
    }
}
