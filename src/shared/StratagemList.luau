--!strict

type Stratagem = {
    sequence: { string },
    name: string
}


-- minimum: 3, maximum: 6
local StratagemList: { [number]: Stratagem } = {}


StratagemList[1] = {
    sequence = { "D", "D", "W" },
    name = "TEST"
}

StratagemList[2] = {
    sequence = { "W", "W", "S", "S", "A", "D" },
    name = "SEQUENCE 2"
}

StratagemList[3] = {
    sequence = { "W", "W", "S", "S", "A", "A" },
    name = "SEQUENCE 3"
}


return StratagemList