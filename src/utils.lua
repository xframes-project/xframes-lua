local module = {}

function module.table_to_string(t, indent)
    indent = indent or 0
    local result = {}
    local spacing = string.rep("  ", indent)

    table.insert(result, spacing .. "{")

    for k, v in pairs(t) do
        local key = tostring(k)
        local value

        if type(v) == "table" then
            value = module.table_to_string(v, indent + 1)
        else
            value = tostring(v)
        end

        table.insert(result, string.format("%s  %s = %s,", spacing, key, value))
    end

    table.insert(result, spacing .. "}")
    return table.concat(result, "\n")
end

function module.table_contains(tbl, val)
    for _, v in pairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

function module.print_error(error_message)
    print(error_message)
    print("-- Stack trace follows --")
    debug.traceback()
end

return module
