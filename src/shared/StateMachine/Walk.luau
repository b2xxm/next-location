local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local WALK_SPEED: number = 8


local Walk = {}
Walk.update = nil
Walk.transitions = {
    Idle = function(flags: PlayerFlags): boolean
        return not flags.i_move
    end,
    Run = function(flags: PlayerFlags): boolean
        return flags.i_run
    end,
    Sneak = function(flags: PlayerFlags): boolean
        return flags.i_crouch and not flags.a_thief
    end,
    Thief = function(flags: PlayerFlags): boolean
        return flags.a_thief
    end,
    Fall = function(flags: PlayerFlags): boolean
        return flags.a_fall
    end
}


function Walk.enter(): ()
    Animation.play("Walk")
    Character.setWalkspeed(WALK_SPEED)
end


function Walk.exit(): ()
    Animation.stop("Walk")
end


return Walk