local Nova = require("@nova/index")

local UserId = {}

local userTable = {
    ["1"] = { name = `John Doe 1`, job = "Lune Developer" },
    ["2"] = { name = `John Doe 2`, job = "Lune Developer" },
    ["3"] = { name = `John Doe 3`, job = "Lune Developer" },
    ["4"] = { name = `John Doe 4`, job = "Lune Developer" },
    ["5"] = { name = `John Doe 5`, job = "Lune Developer" }
}
local userTableforPost = {}


function UserId.Post(req: Nova.RequestWith<{ id: string }>)
    local userId = req.params.id

    if userTableforPost[userId] then 
        return Nova.response.json({ msg = "User already exist" }, { status = 400 })
    end

    userTableforPost[userId] = req.body

    return Nova.response.json({ msg = "Successfully registered new user", current_users = userTable })
end

function UserId.Get(req: Nova.RequestWith<{ id: string }>)
    local userId = req.params.id

    if not userTable[userId] then 
        return Nova.response.json({ msg = "User does not exist" }, { status = 400 })
    end

    return Nova.response.json({ msg = "User " .. userId .. " is found", current_users = userTable  })
end

function UserId.Put(req: Nova.RequestWith<{ id: string }>)
    local userId = req.params.id

    if not userTable[userId] then 
        return Nova.response.json({ msg = "User does not exist" }, { status = 400 })
    end

    userTable[userId] = req.body

    return Nova.response.json({ msg = "User " .. userId .. " is updated", current_users = userTable  })
end

function UserId.Delete(req: Nova.RequestWith<{ id: string }>)
    local userId = req.params.id

    if not userTable[userId] then 
        return Nova.response.json({ msg = "User does not exist" }, { status = 400 })
    end

    userTable[userId] = nil

    return Nova.response.json({ msg = "User " .. userId .. " is deleted", current_users = userTable  })
end

return UserId
