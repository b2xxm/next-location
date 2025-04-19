local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
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


function Crouch.enter(transition: (toState: string) -> ()): ()
    Animation.play("Crouch")
end


function Crouch.exit(): ()
    Animation.stop("Crouch")
end


return Crouch