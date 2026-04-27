local process = require("@lute/process")
local Types = require("./types")

local LuteProcess = {} :: Types.ProcessAdapter

local cwd = process.cwd
local env = process.env
local run = process.run
local exit = process.exit

LuteProcess.cwd = cwd() .. "/"
LuteProcess.env = env :: { [string]: string? }

function LuteProcess.create(exec, args, opts: ProcessOptions?): ProcessChild?
    if not args then 
        return nil
    end

    return run({ exec, args[1], args[2] }, opts :: any) :: any
end

function LuteProcess.exit(code)
    exit(code)
end

return LuteProcess