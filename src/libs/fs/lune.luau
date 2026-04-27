local fs = require("@lune/fs")
local Types = require("./types")

local LuneFs = {} :: Types.FsAdapter

local isFile = fs.isFile
local readFile = fs.readFile
local writeFile = fs.writeFile
local isDir = fs.isDir
local readDir = fs.readDir
local metadata = fs.metadata

function LuneFs.isFile(path: string)
    return isFile(path)
end

function LuneFs.readFile(path: string)
    return readFile(path)
end

function LuneFs.writeFile(path: string, contents: string)
    return writeFile(path, contents)
end

function LuneFs.isDir(path: string)
    return isDir(path)
end

function LuneFs.readDir(path: string)
    return readDir(path)
end

function LuneFs.metadata(path: string)
    return metadata(path) :: any
end

return LuneFs
