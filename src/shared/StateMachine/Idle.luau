local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type StateInput = Types.StateInput


local WALK_SPEED: number = 8


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


function Idle.enter(transition: (toState: string) -> ()): ()
    Animation.play("Idle")
    Character.setWalkspeed(WALK_SPEED)
end


function Idle.exit(): ()
    Animation.stop("Idle")
end


return Idle