local json = require("@std/json")
local Types = require("./types")

local LuneSerde = {} :: Types.SerdeAdapter

function LuneSerde.decode(format, encoded)
    if not (format == "json") then
        error("Unsupported format: " .. format)
    end

    return json.deserialize(encoded)
end

function LuneSerde.encode(format, value, pretty)
    if not (format == "json") then
        error("Unsupported format: " .. format)
    end

    return json.serialize(value, pretty)
end

return LuneSerde
