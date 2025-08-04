local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Config = require(shared.Config)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local RUN_SPEED: number = Config.locomotion.speed.run


local Run = {}
Run.update = nil
Run.transitions = {
    Idle = function(flags: PlayerFlags): boolean
        return not flags.i_move
    end,
    Walk = function(flags: PlayerFlags): boolean
        return not flags.i_run
    end,
    Slide = function(flags: PlayerFlags): boolean
        return flags.a_slide
    end,
    Fall = function(flags: PlayerFlags): boolean
        return flags.a_fall
    end,
    Kong = function(flags: PlayerFlags): boolean
        return flags.a_kong
    end
}


function Run.enter(): ()
    Animation.play("Run")
    Character.setWalkspeed(RUN_SPEED)
end


function Run.exit(): ()
    Animation.stop("Run")
end


return Run :: StateDefinition