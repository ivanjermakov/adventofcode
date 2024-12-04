import std.stdio : writeln;
import std.file : readText;
import std.array;
import std.algorithm;
import std.typecons;

struct Pos {
    int x;
    int y;
};

Nullable!dchar at(dchar[][] grid, Pos pos) {
    if (pos.y >= grid.length) return Nullable!dchar();
    if (pos.x >= grid[pos.y].length) return Nullable!dchar();
    return Nullable!dchar(grid[pos.y][pos.x]);
}

Pos[] direction = [Pos(-1, -1), Pos(1, -1), Pos(0, 0), Pos(-1, 1), Pos(1, 1)];

string[] matches = ["MSAMS", "SSAMM", "MMASS", "SMASM"];

string wordAt(dchar[][] grid, Pos pos, Pos[] dir) {
    string word = "";
    foreach(d; dir) {
        auto c = at(grid, Pos(pos.x + d.x, pos.y + d.y));
        if (!c.isNull) {
            word ~= c.get;
        }
    }
    return word;
}

int countMatches(dchar[][] grid) {
    int count = 0;
    for (int y = 0; y < grid.length; y++) {
        for (int x = 0; x < grid[y].length; x++) {
            auto w = wordAt(grid, Pos(x, y), direction);
            foreach(m; matches) {
                if (w == m) {
                    count++;
                    break;
                }
            }
        }
    }
    return count;
}

void main() {
    auto input = readText("data/day4.txt");
    dchar[][] grid = input.split('\n').filter!(l => l.length > 0).map!(l => l.array).array;
    auto res = countMatches(grid);
    writeln(res);
}
