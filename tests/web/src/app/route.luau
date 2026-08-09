local common = require("@mayari.common")
local Response = common.response

local Home = {}

--@Guard(Auth, Admin)
--@Interceptor(Transform)
function Home.Get()
	return Response.json("Hello, World")
end

--@Validator(createUser)
function Home.Post(req: common.Request)
    return Response.json({ msg = "Got the Response", data = req.body })
end

return Home
