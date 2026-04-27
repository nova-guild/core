local task = zune.task
local Types = require("./types")

local ZuneTask = {} :: Types.TaskAdapter

local wait = task.wait

function ZuneTask.wait(duration)
    return wait(duration)
end

return ZuneTask
