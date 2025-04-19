local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
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
    Animation.play("Idle")
end


function Idle.exit(): ()
    Animation.stop("Idle")
end


return Idle