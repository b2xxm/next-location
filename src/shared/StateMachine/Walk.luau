local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type StateInput = Types.StateInput


local WALK_SPEED: number = 7


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


function Walk.enter(transition: (toState: string) -> ()): ()
    Animation.play("Walk")
    Character.setWalkspeed(WALK_SPEED)
end


function Walk.exit(): ()
    Animation.stop("Walk")
end


return Walk