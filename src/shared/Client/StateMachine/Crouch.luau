local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local Crouch = {}
Crouch.update = nil
Crouch.transitions = {
    Idle = function(flags: PlayerFlags): boolean
        return not flags.i_crouch
    end,
    Sneak = function(flags: PlayerFlags): boolean
        return flags.i_move
    end,
}


function Crouch.enter(): ()
    Animation.play("Crouch")
end


function Crouch.exit(): ()
    Animation.stop("Crouch")
end


return Crouch :: StateDefinition