local process = require("@lune/process")
local fs = require("@lune/fs")

local function loadEnv()
    local envVars = {}
    local success, content = pcall(fs.readFile, ".env" or ".env.local" or ".env.development")
    
    if success then
        for line in content:gmatch("[^\r\n]+") do
            if not line:match("^%s*#") and line:match("=") then
                local key, value = line:match("^%s*([^=]+)%s*=%s*(.-)%s*$")
                if key then
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