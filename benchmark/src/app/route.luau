local Nova = require("@pesde/nova")

local Home = {}

function Home.Get() 
    return Nova.response.json({ msg = "Hello World" })
end

return Home