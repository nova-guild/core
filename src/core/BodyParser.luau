local adpt = require("@mayari.adpt")
local json = adpt.json

type BodyParsers = { [string]: (raw: string) -> string | { any } }

local BodyParser: BodyParsers = {}

BodyParser["text/plain"] = function(raw: string)
    return raw
end

BodyParser["application/json"] = function(raw: string)
    local ok, result = pcall(json.decode, raw)

    if not ok then
        print("Failed to decode JSON body")
        return { "" }
    end

    return result
end

BodyParser["application/x-www-form-urlencoded"] = function(raw: string)
    local data: { [string]: string | { string } } = {}

    local function clearData(str: string)
        return string.gsub(str, "%%(%x%x)", function(hex)
            return string.char(tonumber(hex, 16))
        end)
    end

    for key, value in string.gmatch(raw, "([^&=]+)=([^&]*)") do
        local decodedKey = clearData(key)
        local decodedValue = clearData(value :: string)

        if data[decodedKey] then
            if typeof(data[decodedValue]) == "table" then
                table.insert(data[decodedKey] :: { string }, decodedValue)
            else
                data[decodedKey] = { data[decodedKey] :: string, decodedValue }
            end
        else
            data[decodedKey] = decodedValue
        end
    end

    return data
end

return BodyParser
