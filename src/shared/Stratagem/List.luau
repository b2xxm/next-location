--!strict

type Stratagem = {
    sequence: { string },
    callback: () -> ()
}


-- minimum: 3, maximum: 6
local StratagemList: { [string]: Stratagem } = {}


StratagemList["TEST"] = {
    sequence = { "D", "D", "W" },
    callback = function() print("TEST") end
}

StratagemList["SEQUENCE 2"] = {
    sequence = { "W", "W", "S", "S", "A", "D" },
    callback = function() print("SEQUENCE 2") end
}

StratagemList["SCAN"] = {
    sequence = { "W", "W", "S", "S", "A", "A" },
    callback = function() print("SCAN") end
}


return StratagemList