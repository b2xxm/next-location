local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type StateInput = Types.StateInput


local RUN_SPEED: number = 22


local Run = {}
Run.metadata = {}
Run.transitions = {
    Idle = function(input: StateInput): boolean
        return not input.move
    end,
    Walk = function(input: StateInput): boolean
        return not input.run
    end,
    Slide = function(input: StateInput): boolean
        return input.slide
    end
}


function Run.enter(): ()
    Animation.play("Run")
    Character.setWalkspeed(RUN_SPEED)
end


function Run.exit(): ()
    Animation.stop("Run")
end


return Run