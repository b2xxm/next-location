local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared


local Types = require(shared.Types)


type StateInput = Types.StateInput


local Run = {}
Run.transitions = {
    Idle = function(input: StateInput): boolean
        return not input.move
    end,
    Walk = function(input: StateInput): boolean
        return not input.run
    end
}


function Run.enter(): ()
    print("Run enter")
end


function Run.exit(): ()
    print("Run exit")
end


return Run