local fs = require("@lute/fs")
local process = require("@lute/process")
local Types = require("./types")

local LuteFs = {} :: Types.FsAdapter

local function pathType(path: string): string?
    local result = process.run({ "test", "-f", path })
    if result.ok then return "file" end
    local result2 = process.run({ "test", "-d", path })
    if result2.ok then return "dir" end
    return nil
end

function LuteFs.isFile(path: string)
    return pathType(path) == "file"
end

function LuteFs.isDir(path: string)
    return pathType(path) == "dir"
end

function LuteFs.readFile(path: string): string
    local result = process.run({ "cat", path })
    if result.ok then
        return result.stdout
    else
        return result.stderr
    end
end

function LuteFs.writeFile(path: string, contents: string)
    local ok, err = pcall(function()
        local handle = fs.open(path, "w")
        fs.write(handle, contents)
        fs.close(handle)
    end)
    if not ok then
        error(`Failed to write file '{path}': {err}`)
    end
end

function LuteFs.readDir(path: string)
    local result = process.run({ "ls", "-1", path })
    if not result.ok then
        error("Directory not found: " .. path)
    end
    local names = {}
    for name in result.stdout:gmatch("[^\n]+") do
        table.insert(names, name)
    end
    return names
end

function LuteFs.metadata(path: string)
    local ok, stat = pcall(fs.stat, path)
    if not ok then
        error("Path not found: " .. path)
    end
    return {
        kind = stat.type :: any,
        exists = true,
        createdAt = stat.created:toSeconds(),
        modifiedAt = stat.modified:toSeconds(),
        accessedAt = stat.accessed:toSeconds(),
        permissions = {
            readOnly = stat.permissions.readonly,
        },
    }
end

return LuteFs