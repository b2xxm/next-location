local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared


local Types = require(shared.Types)


type StateInput = Types.StateInput


local Idle = {}
Idle.transitions = {
    Walk = function(input: StateInput): boolean
        return input.move and not input.run
    end,
    Run = function(input: StateInput): boolean
        return input.move and input.run
    end,
    Crouch = function(input: StateInput): boolean
        return input.crouch
    end,
}


function Idle.enter(): ()
    print("Idle enter")
end


function Idle.exit(): ()
    print("Idle exit")
end


return Idle