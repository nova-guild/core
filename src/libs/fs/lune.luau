local fs = require("@lune/fs")
local Types = require("./types")

local LuneFs = {} :: Types.FsAdapter

function LuneFs.isFile(path: string)
    return fs.isFile(path)
end

function LuneFs.readFile(path: string)
    return fs.readFile(path)
end

function LuneFs.writeFile(path: string, contents: string)
    return fs.writeFile(path, contents)
end

function LuneFs.isDir(path: string)
    return fs.isDir(path)
end

function LuneFs.readDir(path: string)
    return fs.readDir(path)
end

function LuneFs.metadata(path: string)
    return fs.metadata(path) :: any
end

return LuneFs
