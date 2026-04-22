local Nova = require("@nova/index")

local app = Nova.new(8080)

app:listen(function() 
    print(`Nova is running on PORT {8080}`)
end)
