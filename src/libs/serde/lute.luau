local json = require("@std/json")
local Types = require("./types")

local LuneSerde = {} :: Types.SerdeAdapter

local deserialize = json.deserialize
local serialize = json.serialize

function LuneSerde.decode(format, encoded)
    if not (format == "json") then
        error("Unsupported format: " .. format)
    end

    return deserialize(encoded)
end

function LuneSerde.encode(format, value, pretty)
    if not (format == "json") then
        error("Unsupported format: " .. format)
    end

    return serialize(value, pretty)
end

return LuneSerde
