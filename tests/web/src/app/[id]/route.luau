local common = require("@mayari.common")
local Response = common.response

local Home = {}

function Home.Get(banana: common.RequestWith<{ id: string }>)
	local userId = banana.params.id
	return Response.json({ userId = userId, msg = "Found a user ID" })
end

return Home
