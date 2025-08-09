local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local Hang = {}
Hang.transitions = {
    Fall = function(flags: PlayerFlags): boolean
        return flags.i_run and flags.i_moveAction
    end
}


function Hang.enter(): ()
    Animation.play("Hang")
    Character.toggleVelocity(true, nil, 0)
end


function Hang.exit(): ()
    Animation.stop("Hang")
    Character.toggleVelocity(false)
end


return Hang :: StateDefinition