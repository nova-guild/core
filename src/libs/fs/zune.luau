local fs = zune.fs
local Types = require("./types")

local ZuneFs = {} :: Types.FsAdapter

function ZuneFs.isFile(path: string)
    local stat = fs.stat(path)
    return stat.kind == "file"
end

function ZuneFs.readFile(path: string)
    return fs.readFile(path)
end

function ZuneFs.writeFile(path: string, contents: string)
    return fs.writeFile(path, contents)
end

function ZuneFs.isDir(path: string)
    local stat = fs.stat(path)
    return stat.kind == "directory"
end

function ZuneFs.readDir(path: string)
    local result = {}
    for _, entry in fs.entries(path) do
        table.insert(result, entry.name)
    end
    return result
end

function ZuneFs.metadata(path: string)
    return fs.metadata(path) :: any
end

return ZuneFs
