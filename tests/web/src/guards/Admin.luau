local common = require("@mayari.common")

local function Admin(_req: common.Request)
    print("Admin Check")
	return true
end

return Admin
