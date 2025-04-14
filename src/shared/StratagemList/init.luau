--!strict

type Stratagem = {
    sequence: { string }
}


-- minimum: 3, maximum: 6
local StratagemList: { [string]: Stratagem } = {}


StratagemList["TEST"] = {
    sequence = { "D", "D", "W" }
}

StratagemList["SEQUENCE 2"] = {
    sequence = { "W", "W", "S", "S", "A", "D" }
}

StratagemList["SCAN"] = {
    sequence = { "W", "W", "S", "S", "A", "A" }
}


return StratagemList