--!strict

type Stratagem = {
    sequence: { string },
    callback: () -> ()
}


-- minimum: 3, maximum: 6
local StratagemList: { [string]: Stratagem } = {}


StratagemList["TEST"] = {
    sequence = { "D", "D", "W" },
    callback = require(script.TempTest)
}

StratagemList["SEQUENCE 2"] = {
    sequence = { "W", "W", "S", "S", "A", "D" },
    callback = function() end
}

StratagemList["SCAN"] = {
    sequence = { "W", "W", "S", "S", "A", "A" },
    callback = function() end
}


return StratagemList