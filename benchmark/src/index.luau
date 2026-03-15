local Nova = require("@pesde/nova")
local process = require("@lune/process")

local PORT = tonumber(process.env.PORT) or 8080
local app = Nova.new(PORT)

app:listen(function()
    print(`Server is running on PORT {PORT}`)
end)

