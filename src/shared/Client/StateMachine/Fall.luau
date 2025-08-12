local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Config = require(shared.Config)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local WALK_SPEED: number = Config.locomotion.speed.perpendicularFall


local Fall = {}
Fall.update = nil
Fall.transitions = {
    Land = function(flags: PlayerFlags): boolean
        return flags.a_land
    end
}


function Fall.enter(): ()
    Character.setWalkspeed(WALK_SPEED)
    Character.toggleVelocity(false)
    
    Animation.play("Fall")
end


function Fall.exit(): ()
    Animation.stop("Fall")
end


return Fall :: StateDefinition