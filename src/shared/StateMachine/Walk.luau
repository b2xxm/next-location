local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared


local Types = require(shared.Types)


type StateInput = Types.StateInput


local Walk = {}
Walk.transitions = {
    Idle = function(input: StateInput): boolean
        return not input.move
    end,
    Run = function(input: StateInput): boolean
        return input.run
    end,
    Sneak = function(input: StateInput): boolean
        return input.crouch
    end,
}


function Walk.enter(): ()
    print("Walk enter")
end


function Walk.exit(): ()
    print("Walk exit")
end


return Walk