local fs = require("@lute/fs")
local Types = require("./types")

local LuteFs = {} :: Types.FsAdapter

local stat = fs.stat
local open = fs.open
local read = fs.read
local close = fs.close
local write = fs.write
local listdir = fs.listdir

function LuteFs.isFile(path: string)
    local ok, err = pcall(function()  
        return stat(path).type == "file"
    end)

    return if ok then err else ok
end

function LuteFs.isDir(path: string)
    local ok, err = pcall(function()  
        return stat(path).type == "dir"
    end)

    return if ok then err else ok
end

function LuteFs.readFile(path: string): string
    local fileHandle = open(path)
    local fileContent = read(fileHandle)
    close(fileHandle)

    return fileContent
end

function LuteFs.writeFile(path: string, contents: string)
    local ok, err = pcall(function()
        local handle = open(path, "w")
        write(handle, contents)
        close(handle)
    end)
    if not ok then
        error(`Failed to write file '{path}': {err}`)
    end
end

function LuteFs.readDir(path: string)
    local dirEntry: {fs.DirectoryEntry} = listdir(path)
    local dirList = {}

    for i = 1, table.maxn(dirEntry) do
        table.insert(dirList, dirEntry[i].name)
    end

    return dirList
end

function LuteFs.metadata(path: string)
    local ok, fileStat = pcall(stat, path)
    if not ok then
        error("Path not found: " .. path)
    end
    return {
        kind = fileStat.type :: any,
        exists = true,
        createdAt = fileStat.created:toSeconds(),
        modifiedAt = fileStat.modified:toSeconds(),
        accessedAt = fileStat.accessed:toSeconds(),
        permissions = {
            readOnly = fileStat.permissions.readonly,
        },
    }
end

return LuteFs