-- nova/src/libs/process/lune.luau
local process = require("@lune/process")
local Types = require("./types")

local LuneProcess = {} :: Types.ProcessAdapter

local cwd = process.cwd
local env = process.env
local create = process.create
local exit = process.exit

LuneProcess.cwd = cwd
LuneProcess.env = env

function LuneProcess.create(exec, args, opts)
    return create(exec, args, opts) :: any
end

function LuneProcess.exit(code)
    exit(code)
end

return LuneProcess