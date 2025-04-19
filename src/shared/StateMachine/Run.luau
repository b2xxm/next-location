local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
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
    Animation.play("Run")
end


function Run.exit(): ()
    Animation.stop("Run")
end


return Run