local task = require("@lune/task")
local Types = require("./types")

local LuneTask = {} :: Types.TaskAdapter

local wait = task.wait

function LuneTask.wait(duration)
    return wait(duration)
end

return LuneTask
