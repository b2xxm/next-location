local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type StateInput = Types.StateInput


local DURATION: number = 1


local Slide = {}
Slide.metadata = {
    autoExit = {
        delay = DURATION,
        callback = function(input: StateInput)
            input.slide = false
        end
    }
}

Slide.transitions = {
    Walk = function(input: StateInput): boolean
        return input.move and not input.run and not input.slide
    end,
    Run = function(input: StateInput): boolean
        return input.move and input.run and not input.slide
    end,
    Idle = function(input: StateInput): boolean
        return not input.move and not input.slide
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