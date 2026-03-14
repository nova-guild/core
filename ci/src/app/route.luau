local Nova = require("../../../src/index")

local Home = {}

function Home.Get()
    return Nova.response.json({ msg = "Hello World" })
end

return Home