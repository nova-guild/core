local common = require("@mayari.common")

local function Transform(_req: common.Request, next: common.Next)
    next()
end

return Transform
