local Nova = require("../../../../src/index")

local Users = {}

function Users.Get()
    return Nova.response.json({ msg = "Hello Users" })
end

return Users