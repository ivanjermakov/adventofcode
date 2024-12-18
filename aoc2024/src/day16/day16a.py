import heapq
import math

with open('data/day16.txt') as f:
    grid = f.read().splitlines()

q = []
dist = {}
visited = set()
for i, row in enumerate(grid):
    for j, c in enumerate(row):
        pos = (i, j)
        if c == 'S':
            start = pos
            continue
        if c == 'E':
            target = pos
        if c != '#':
            for d in range(4):
                dist[pos] = math.inf

heapq.heappush(q, (0, start, 1))
dist[start] = 0
while q:
    udist, upos, udir = heapq.heappop(q)
    if upos in visited:
        continue
    visited.add(upos)
    if upos == target:
        break
    for vdir, doff in enumerate([(-1, 0), (0, 1), (1, 0), (0, -1)]):
        if vdir != (udir + 2) % 4:
            vpos = (upos[0] + doff[0], upos[1] + doff[1])
            if vpos in dist:
                turned = udir != vdir
                d = udist + 1 + (1000 if turned else 0)
                if d < dist[vpos]:
                    dist[vpos] = d
                    heapq.heappush(q, (d, vpos, vdir))

print(dist[target])
