local process = require("../libs/process")
local fs = require("../libs/fs")

local function loadEnv()
    local envVars: { [string]: string } = {}
    local content: string?

    for _, filename in { ".env", ".env.local", ".env.development" } do
        local success, result = pcall(fs.readFile, filename)
        if success then
            content = result
            break
        end
    end

    if content then
        for line in content:gmatch("[^\r\n]+") do
            if not line:match("^%s*#") and line:match("=") then
                local key, value = line:match("^%s*([^=]+)%s*=%s*(.-)%s*$")
                if key and value then
                    value = value:gsub("^[\"'](.-)[\"']$", "%1")
                    envVars[key] = value
                    process.env[key] = value
                end
            end
        end
    end

    return envVars
end

return loadEnv