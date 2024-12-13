import java.nio.file.*;
import java.util.*;
import java.util.regex.*;
import java.math.*;

public class Day13b {
    public static void main(String[] args) throws Exception {
        var input = Files.readString(Paths.get("data/day13.txt"));
        var res = Arrays.stream(input.split("\n\n"))
            .map(Day13b::solve)
            .reduce(BigInteger.ZERO, BigInteger::add);
        System.out.println(res);
    }

    static BigInteger solve(String group) {
        var factor = new BigDecimal("10000000000000");

        var matcher = Pattern.compile("\\d+").matcher(group);
        var matches = matcher.results().map(MatchResult::group).map(Integer::parseInt).toList();
        var i = 0;
        var x1 = BigDecimal.valueOf(matches.get(i++));
        var y1 = BigDecimal.valueOf(matches.get(i++));
        var x2 = BigDecimal.valueOf(matches.get(i++));
        var y2 = BigDecimal.valueOf(matches.get(i++));
        var c = BigDecimal.valueOf(matches.get(i++)).add(factor);
        var d = BigDecimal.valueOf(matches.get(i++)).add(factor);

        var div = x1.multiply(y2).subtract(y1.multiply(x2));
        try {
            var a = (c.multiply(y2).subtract(d.multiply(x2))).divide(div).toBigIntegerExact();
            var b = (d.multiply(x1).subtract(c.multiply(y1))).divide(div).toBigIntegerExact();
            return a.multiply(BigInteger.valueOf(3)).add(b);
        } catch (ArithmeticException e) {}
        return BigInteger.ZERO;
    }

    static int gcd(int a, int b) {
        if (b == 0) return a;
        return gcd(b, a % b);
    }
}
