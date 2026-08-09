local common = require("@mayari.common")
local Response = common.response
local Home = {}

function Home.Get(req: common.RequestWith<{ ids: { string } }>)
	local userIds = req.params.ids
	return Response.json({ userIds = userIds, msg = "Found user IDs" })
end

return Home
