local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local DURATION: number = 1


local elapsed: number = 0


local Slide = {}
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
    elapsed = 0

    Character.enableForwardVelocity(22) -- arbitrary
    Animation.play("Slide")
end


function Slide.exit(): ()
    Character.disableForwardVelocity()
    Animation.stop("Slide")
end


function Slide.update(deltaTime: number, flags: PlayerFlags): boolean
    elapsed += deltaTime

    if elapsed >= DURATION then
        flags.a_slide = false

        return true
    end

    return false
end


return Slide