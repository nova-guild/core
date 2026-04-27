local fs = zune.fs
local Types = require("./types")

local ZuneFs = {} :: Types.FsAdapter

local stat = fs.stat
local readFile = fs.readFile
local writeFile = fs.writeFile

function ZuneFs.isFile(path: string)
    local fileStat = stat(path)
    return fileStat.kind == "file"
end

function ZuneFs.readFile(path: string)
    return readFile(path)
end

function ZuneFs.writeFile(path: string, contents: string)
    return writeFile(path, contents)
end

function ZuneFs.isDir(path: string)
    local fileStat = stat(path)
    return fileStat.kind == "directory"
end

function ZuneFs.readDir(path: string)
    local result = {}
    for _, entry in fs.entries(path) do
        table.insert(result, entry.name)
    end
    return result
end

function ZuneFs.metadata(path: string)
    local metadata = fs.metadata(path)

    return {
        kind = metadata.kind == "directory" and "dir",
        exists = true,
        createdAt = metadata.created_at,
        modifiedAt = metadata.modified_at,
        accessedAt = metadata.accessed_at,
        permissions = {
            readOnly = metadata.permissions.read_only
        }
    } :: Types.FsMetadata
end

return ZuneFs
