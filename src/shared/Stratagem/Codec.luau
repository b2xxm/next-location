--!strict

local bitsToChar = { [0] = "W", [1] = "D", [2] = "S", [3] = "A" }
local charToBits = { ["W"] = 0, ["D"] = 1, ["S"] = 2, ["A"] = 3 }


-- this module is useless and storing the stratagem sequence as a buffer is probably a waste of effort
-- will not be used, unless a feature where the stratagem sequence is networked is found
local StratagemCodec = {}


function StratagemCodec.encode(sequenceList: { string }): buffer
    local length = #sequenceList

    if length < 3 or length > 6 then
        error("invalid sequence length")
    end

    local sequence = buffer.create(2)

    buffer.writebits(sequence, 0, 2, length - 3) -- [-3] to get value down to 2 bits

    for index, character in sequenceList do
        local offset = index * 2 -- 2 bits are written at a time
        local bits = charToBits[character]
        
        buffer.writebits(sequence, offset, 2, bits)
    end

    return sequence
end


function StratagemCodec.decode(sequence: buffer): { string }
    local length = buffer.readbits(sequence, 0, 2) + 3 -- 2 bit header specifies length of sequence, [+3] to get 3 - 6 range
    local sequenceList = table.create(length)

    for count = 1, length do
        local offset = count * 2 -- 2 bits are read at a time
        local bits = buffer.readbits(sequence, offset, 2) -- the 2 bits represent [WDSA]
        local character = bitsToChar[bits]
        
        table.insert(sequenceList, character)
    end

    return sequenceList
end


return StratagemCodec