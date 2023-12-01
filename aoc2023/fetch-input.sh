DAY=$1
OUT="data/day$DAY.txt"

if [[ ! $SESSION ]]; then
    echo "SESSION is not set"
    exit 1
fi
echo "session id: $SESSION"
echo "day: $DAY"
echo "out: $OUT"

curl -s --header "Cookie: session=$SESSION" "https://adventofcode.com/2023/day/$DAY/input" > $OUT 2>&1

