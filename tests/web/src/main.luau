local mayari = require("@mayari")
local adpt = require("@mayari.adpt")

local process = adpt.process

local function myMiddleware(_req: mayari.Request, next: mayari.Next)
    print("lorem")
    next()
end

local PORT = tonumber(process.env.PORT) or 8080
local app = mayari.new(PORT, {
    myMiddleware,
    function(_req: mayari.Request, next: mayari.Next)
        next()
    end
})

app:listen(function()
	print(`Mayari is running on Port {PORT}`)
end)
