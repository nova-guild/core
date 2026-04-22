local process = require("@lute/process")
local Types = require("./types")

local LuteProcess = {} :: Types.ProcessAdapter

LuteProcess.cwd = process.cwd() .. "/"
LuteProcess.env = process.env :: { [string]: string? }

function LuteProcess.create(exec, args, opts: ProcessOptions?): ProcessChild?
    if not args then 
        return nil
    end

    return process.run({ exec, args[1], args[2] }, opts) :: any
end

return LuteProcess