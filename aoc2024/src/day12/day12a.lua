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

local function perimeter(group, grid)
    local per = 0
    for _, p in ipairs(group) do
        for _, n in ipairs({
            { i = -1, j = 0 }, { i = 1, j = 0 }, { i = 0, j = -1 }, { i = 0, j = 1 }
        }) do
            local np = { i = n.i + p.i, j = n.j + p.j }
            if grid[np.i] and grid[np.i][np.j] == group.plant then
            else
                per = per + 1
            end
        end
    end
    return per
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
    cost = cost + #group * perimeter(group, grid)
end
pretty_print(cost)
