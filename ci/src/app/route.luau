local Nova = require("@nova/index")

local Home = {}

function Home.Get(req: Nova.Request)
    
    return Nova.response.send("Hello, World")
end

return Home