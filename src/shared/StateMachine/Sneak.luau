local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
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
    Animation.play("Sneak")
end


function Sneak.exit(): ()
    Animation.stop("Sneak")
end


return Sneak