local common = require("@mayari.common")

local function Auth(_req: common.Request)
    print("Auth Check")
	return true
end

return Auth
