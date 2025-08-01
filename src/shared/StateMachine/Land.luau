local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local DURATION: number = 0.4
local WALK_SPEED: number = 3


local elapsed: number = 0


local Land = {}
Land.transitions = {
    Walk = function(flags: PlayerFlags): boolean
        return flags.i_move and not flags.i_run and not flags.a_land
    end,
    Run = function(flags: PlayerFlags): boolean
        return flags.i_move and flags.i_run and not flags.a_land
    end,
    Idle = function(flags: PlayerFlags): boolean
        return not flags.i_move and not flags.a_land
    end
}


function Land.enter(): ()
    elapsed = 0

    Character.setWalkspeed(WALK_SPEED)
    Animation.play("Land")
end


function Land.exit(): ()
    Animation.stop("Land")
end


function Land.update(deltaTime: number, flags: PlayerFlags): boolean
    elapsed += deltaTime

    if elapsed >= DURATION then
        flags.a_land = false

        return true
    end

    return false
end


return Land