local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Config = require(shared.Config)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local SNEAK_SPEED: number = Config.locomotion.speed.sneak


local Sneak = {}
Sneak.update = nil
Sneak.transitions = {
    Walk = function(flags: PlayerFlags): boolean
        return not flags.i_crouch and not flags.i_run
    end,
    Run = function(flags: PlayerFlags): boolean
        return not flags.i_crouch and flags.i_run
    end,
    Crouch = function(flags: PlayerFlags): boolean
        return not flags.i_move
    end,
    Fall = function(flags: PlayerFlags): boolean
        return flags.a_fall
    end
}


function Sneak.enter(): ()
    Animation.play("Sneak")
    Character.setWalkspeed(SNEAK_SPEED)
end


function Sneak.exit(): ()
    Animation.stop("Sneak")
end


return Sneak :: StateDefinition