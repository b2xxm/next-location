local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local SNEAK_SPEED: number = 4


local Sneak = {}
Sneak.metadata = {}
Sneak.transitions = {
    Walk = function(flags: PlayerFlags): boolean
        return not flags.i_crouch
    end,
    Crouch = function(flags: PlayerFlags): boolean
        return not flags.i_move
    end
}


function Sneak.enter(): ()
    Animation.play("Sneak")
    Character.setWalkspeed(SNEAK_SPEED)
end


function Sneak.exit(): ()
    Animation.stop("Sneak")
end


return Sneak