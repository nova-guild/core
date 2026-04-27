-- nova/src/libs/process/zune.luau
local process = zune.process
local Types = require("./types")

local ZuneProcess = {} :: Types.ProcessAdapter

ZuneProcess.cwd = process.cwd() .. "/"
ZuneProcess.env = process.env :: { [string]: string? }

function ZuneProcess.create(exec, args, opts)
    return process.create(exec, args, opts)
end

function ZuneProcess.exit(code)
    process.exit(code)
end

return ZuneProcess