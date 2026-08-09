local common = require("@mayari.common")
local UserService = require("./users.service")

local Response = common.response

local Users = {}

function Users.Get()
	return Response.json(UserService.getUser(123))
end

return Users
