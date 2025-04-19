local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared


local Types = require(shared.Types)


type StateInput = Types.StateInput


local Sneak = {}
Sneak.transitions = {
    Walk = function(input: StateInput): boolean
        return not input.crouch
    end,
    Crouch = function(input: StateInput): boolean
        return not input.move
    end
}


function Sneak.enter(): ()
    print("Sneak enter")
end


function Sneak.exit(): ()
    print("Sneak exit")
end


return Sneak