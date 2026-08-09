local registry = require("./RegistryGenerator").registry
local common = require("@mayari.common")
local Response = common.response

local function validateBody(schema: { [string]: common.BodyField }, data: { [string]: any }): { string }
    local errors = {}

    for field, rules in schema do
        local value = data[field]

        if rules.required and value == nil then
            table.insert(errors, `{field} is required`)
            continue
        end

        if value == nil then
            continue
        end

        if rules.type and type(value) ~= rules.type then
            table.insert(errors, `{field} must be a {rules.type}`)
            continue
        end

        if rules.pattern and not tostring(value):match(rules.pattern) then
            table.insert(errors, `{field} does not match expected pattern`)
        end

        if type(value) == "number" then
            if rules.min and value < rules.min then
                table.insert(errors, `{field} must be at least {rules.min}`)
            end
            if rules.max and value > rules.max then
                table.insert(errors, `{field} must be at most {rules.max}`)
            end
        end

        if type(value) == "string" then
            if rules.min and #value < rules.min then
                table.insert(errors, `{field} must be at least {rules.min} characters`)
            end
            if rules.max and #value > rules.max then
                table.insert(errors, `{field} must be at most {rules.max} characters`)
            end
        end
    end

    return errors
end

local function validateString(schema: { [string]: common.StringField }, data: { [string]: any }): { string }
    local errors = {}

    for field, rules in schema do
        local value = data[field]

        if rules.required and value == nil then
            table.insert(errors, `{field} is required`)
            continue
        end

        if value == nil then
            continue
        end

        local str = tostring(value)

        if rules.pattern and not str:match(rules.pattern) then
            table.insert(errors, `{field} does not match expected pattern`)
        end

        if rules.minLength and #str < rules.minLength then
            table.insert(errors, `{field} must be at least {rules.minLength} characters`)
        end

        if rules.maxLength and #str > rules.maxLength then
            table.insert(errors, `{field} must be at most {rules.maxLength} characters`)
        end
    end

    return errors
end

local function Validator(args: { string })
    return function(req: common.Request, next: common.Next)
        local attribute = registry["Validator"]

        if not attribute then
            return next()
        end

        for _, arg in ipairs(args) do
            local rule = (attribute[arg] :: any) :: common.ValidatorSchema

            if not rule then
                continue
            end

            local errors = {}

            if rule.body then
                for _, err in validateBody(rule.body, req.body :: any or {}) do
                    table.insert(errors, err)
                end
            end

            if rule.params then
                for _, err in validateString(rule.params, req.params or {}) do
                    table.insert(errors, err)
                end
            end

            if rule.query then
                for _, err in validateString(rule.query, req.query or {}) do
                    table.insert(errors, err)
                end
            end

            if #errors > 0 then
                return Response.json({
                    message = errors,
                    error = "Bad Request",
                }, { status = 400 })
            end
        end

        return next()
    end
end

return Validator
