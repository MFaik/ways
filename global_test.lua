setmetatable(_G, {
    __newindex = function(_, name, value)
        error("Attempt to create global variable: " .. name, 2)
    end,
    __index = function(_, name)
        error("Attempt to access undefined global variable: " .. name, 2)
    end,
})
