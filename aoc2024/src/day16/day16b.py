import heapq
import math
from collections import defaultdict

with open('data/day16.txt') as f:
    grid = f.read().splitlines()

q = []
dist = {}
paths = defaultdict(list)
for i, row in enumerate(grid):
    for j, c in enumerate(row):
        pos = (i, j)
        paths[pos] = []
        if c == 'S':
            start = pos
            continue
        if c == 'E':
            target = pos
        if c != '#':
            for d in range(4):
                dist[pos] = math.inf

heapq.heappush(q, (0, start, 1, [start]))
dist[start] = 0
paths[start].append(start)
while q:
    udist, upos, udir, upath = heapq.heappop(q)
    if udist > dist[upos] + 1000:
        continue
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
                    paths[vpos] = [upath + [vpos]]
                    heapq.heappush(q, (d, vpos, vdir, upath + [vpos]))
                else:
                    paths[vpos].append(upath + [vpos])
                    heapq.heappush(q, (d, vpos, vdir, upath + [vpos]))

cells = set([i for s in paths[target] for i in s])
print(len(cells))
