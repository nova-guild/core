local Aura = require("@pesde/aura")
local process = require("@lune/process")
local task = require("@lune/task")

local Tester = {}

function Tester.describe(name, callback)
    local server = process.create("lune", { "run", "src/index" }, { env = process.env })
    
    local ready = false
    for i = 1, 10 do
        local success = pcall(function()
            return Aura.get({ url = "http://localhost:8080", timeout = 500 })
        end)
        if success then ready = true; break end
        task.wait(0.5)
    end

    if not ready then
        server:kill()
        error(`[{name}] Server failed to respond.`)
    end

    print(`--- Running: {name} ---`)

    local success, err = pcall(callback)

    server:kill()
    task.wait(0.2)

    if not success then
        error(`Test Suite [{name}] failed: {err}`)
    else
        print(`✅ {name} passed.`)
    end
end

return Tester