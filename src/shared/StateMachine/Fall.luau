local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


--local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local WALK_SPEED: number = 10


local Fall = {}
Fall.update = nil
Fall.transitions = {
    Land = function(flags: PlayerFlags): boolean
        return flags.a_land
    end
}


function Fall.enter(): ()
    Character.setWalkspeed(WALK_SPEED)
    --Animation.play("Fall")
end


function Fall.exit(): ()
    --Animation.stop("Fall")
end


return Fall