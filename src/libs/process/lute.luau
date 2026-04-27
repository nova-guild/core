local process = require("@lute/process")
local Types = require("./types")

local LuteProcess = {} :: Types.ProcessAdapter

LuteProcess.cwd = process.cwd() .. "/"
LuteProcess.env = process.env :: { [string]: string? }

function LuteProcess.create(exec, args, opts: ProcessOptions?): ProcessChild?
    if not args then 
        return nil
    end

    -- local query = table.concat(args, " ")
    -- query = `{exec} {query}`
    
    -- return process.run({"sh", 
    --     "-c", 
    --     `{query} &`
    -- }, opts) :: any
    return process.run({ exec, args[1], args[2] }, opts :: any) :: any
end

function LuteProcess.exit(code)
    process.exit(code)
end

return LuteProcess