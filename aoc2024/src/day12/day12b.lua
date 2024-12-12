local function pretty_print(value, indent)
    indent = indent or 0
    local indentStr = string.rep("  ", indent)
    if type(value) == "table" then
        io.write("{\n")
        for k, v in pairs(value) do
            io.write(indentStr .. "  " .. tostring(k) .. " = ")
            pretty_print(v, indent + 1)
        end
        io.write(indentStr .. "}\n")
    elseif type(value) == "string" then
        io.write(string.format("%q\n", value))
    else
        io.write(tostring(value) .. "\n")
    end
end

local function parse_grid(input)
    local grid = {}
    for line in input:gmatch("[^\r\n]+") do
        local row = {}
        for char in line:gmatch(".") do
            table.insert(row, char)
        end
        table.insert(grid, row)
    end
    return grid
end

local function corner(a, b)
    local ci = nil
    if a.i ~= 0 then ci = a.i else ci = b.i end
    local cj = nil
    if a.j ~= 0 then cj = a.j else cj = b.j end
    return { i = ci, j = cj }
end

local function sides(group, grid)
    local ss = 0
    for _, p in ipairs(group) do
        local dp = { { i = -1, j = 0 }, { i = 0, j = 1 }, { i = 1, j = 0 }, { i = 0, j = -1 }, { i = -1, j = 0 } }
        for i = 1, 4 do
            local na = { i = dp[i].i + p.i, j = dp[i].j + p.j }
            local nb = { i = dp[i + 1].i + p.i, j = dp[i + 1].j + p.j }
            if not (grid[na.i] and grid[na.i][na.j] == group.plant) and
                not (grid[nb.i] and grid[nb.i][nb.j] == group.plant) then
                -- outside corner
                ss = ss + 1
            end
            local dc = corner(dp[i], dp[i + 1])
            local c = { i = p.i + dc.i, j = p.j + dc.j }
            if (grid[na.i] and grid[na.i][na.j] == group.plant) and
                (grid[nb.i] and grid[nb.i][nb.j] == group.plant) and
                not (grid[c.i] and grid[c.i][c.j] == group.plant) then
                -- inside corner
                ss = ss + 1
            end
        end
    end
    return ss
end

local input = io.open('data/day12.txt', 'r'):read('a')
local grid = parse_grid(input)

local visited = {}
for _ in pairs(grid) do
    table.insert(visited, {})
end

local groups = {}
for i, row in ipairs(grid) do
    for j, plant in ipairs(row) do
        if not visited[i][j] then
            local group = { plant = plant }
            local q = { { i = i, j = j } }
            while #q > 0 do
                local p = table.remove(q, 1)
                if grid[p.i] and grid[p.i][p.j] == plant then
                    visited[p.i][p.j] = true
                    table.insert(group, p)
                    for _, n in ipairs({
                        { i = -1, j = 0 }, { i = 1, j = 0 }, { i = 0, j = -1 }, { i = 0, j = 1 }
                    }) do
                        local np = { i = n.i + p.i, j = n.j + p.j }
                        if visited[np.i] and not visited[np.i][np.j] and grid[np.i][np.j] == plant then
                            visited[np.i][np.j] = true
                            table.insert(q, np)
                        end
                    end
                end
            end
            table.insert(groups, group)
        end
    end
end

local cost = 0
for _, group in ipairs(groups) do
    cost = cost + #group * sides(group, grid)
end
pretty_print(cost)
