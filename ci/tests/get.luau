local Aura = require("@pesde/aura")
local Tester = require("../utils/tester")

Tester.describe("POST Method", function()
    for i = 1, 5 do 
        local res = Aura.get({ 
            url = `http://localhost:8080/users/{i}`,
        })
        
        if not res.ok then 
            error(`Failed at {i} with status {res.status}`) 
        end
        print(`Test {i} passed!`)
    end
end)