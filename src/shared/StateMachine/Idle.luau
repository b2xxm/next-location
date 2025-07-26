local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local WALK_SPEED: number = 8


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
        return flags.i_crouch and not flags.a_vault
    end,
    Thief = function(flags: PlayerFlags): boolean
        return flags.a_vault
    end
}


function Idle.enter(): ()
    Animation.play("Idle")
    Character.setWalkspeed(WALK_SPEED)
end


function Idle.exit(): ()
    Animation.stop("Idle")
end


return Idle