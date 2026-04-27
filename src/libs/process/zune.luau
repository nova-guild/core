-- nova/src/libs/process/zune.luau
local process = zune.process
local Types = require("./types")

local ZuneProcess = {} :: Types.ProcessAdapter

local cwd = process.cwd
local env = process.env
local create = process.create
local exit = process.exit

ZuneProcess.cwd = cwd() .. "/"
ZuneProcess.env = env :: { [string]: string? }

function ZuneProcess.create(exec, args, opts)
    return create(exec, args, opts)
end

function ZuneProcess.exit(code)
    exit(code)
end

return ZuneProcess