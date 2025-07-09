local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local DURATION: number = 1


local Slide = {}
Slide.metadata = {
    autoExit = {
        delay = DURATION,
        callback = function(flags: PlayerFlags)
            flags.a_slide = false
        end
    }
}

Slide.transitions = {
    Walk = function(flags: PlayerFlags): boolean
        return flags.i_move and not flags.i_run and not flags.a_slide
    end,
    Run = function(flags: PlayerFlags): boolean
        return flags.i_move and flags.i_run and not flags.a_slide
    end,
    Idle = function(flags: PlayerFlags): boolean
        return not flags.i_move and not flags.a_slide
    end
}


function Slide.enter(): ()
    Character.enableSlideVelocity()
    Animation.play("Slide")
end


function Slide.exit(): ()
    Character.disableSlideVelocity()
    Animation.stop("Slide")
end


return Slide