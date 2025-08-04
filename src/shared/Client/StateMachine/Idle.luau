local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local Idle = {}
Idle.update = nil
Idle.transitions = {
    Walk = function(flags: PlayerFlags): boolean
        return flags.i_move and not flags.i_run
    end,
    Run = function(flags: PlayerFlags): boolean
        return flags.i_move and flags.i_run
    end,
    Crouch = function(flags: PlayerFlags): boolean
        return flags.i_crouch and not flags.a_thief
    end,
    Thief = function(flags: PlayerFlags): boolean
        return flags.a_thief
    end
}


function Idle.enter(): ()
    Animation.play("Idle")
end


function Idle.exit(): ()
    Animation.stop("Idle")
end


return Idle :: StateDefinition