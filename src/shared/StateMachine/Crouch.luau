local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared


local Types = require(shared.Types)


type StateInput = Types.StateInput


local Crouch = {}
Crouch.transitions = {
    Idle = function(input: StateInput): boolean
        return not input.crouch
    end,
    Sneak = function(input: StateInput): boolean
        return input.move
    end,
}


function Crouch.enter(): ()
    print("Crouch enter")
end


function Crouch.exit(): ()
    print("Crouch exit")
end


return Crouch