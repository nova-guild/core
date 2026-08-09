local mayari = require("@mayari")
local adpt = require("@mayari.adpt")

local process = adpt.process

local PORT = tonumber(process.env.PORT) or 8080
local app = mayari.new(PORT, {
    function(_req, next)
        return next()
    end,
    function(_req, next)
        return next()
    end
})

app:listen(function()
	print(`Mayari is running on Port {PORT}`)
end)
