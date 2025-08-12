local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Config = require(shared.Config)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local DURATION: number = Config.locomotion.duration.climb

local climbOffset: Vector3 = Config.offset.climbFinish


local elapsed: number = 0
local finished: boolean = false


local Climb = {} :: StateDefinition
Climb.transitions = {
    Walk = function(flags: PlayerFlags): boolean
        return flags.i_move and not flags.i_run and finished
    end,
    Run = function(flags: PlayerFlags): boolean
        return flags.i_move and flags.i_run and finished
    end,
    Idle = function(flags: PlayerFlags): boolean
        return not flags.i_move and finished
    end
}


function Climb.enter(): ()
    elapsed = 0
    finished = false

    Animation.play("Climb")
end


function Climb.exit(): ()
    local character = Character.get()
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    Animation.stop("Climb")
    Character.toggleVelocity(false)
    
    rootPart.CFrame *= CFrame.new(0, climbOffset.Y, -climbOffset.X)
end


function Climb.update(deltaTime: number, flags: PlayerFlags): boolean
    elapsed += deltaTime

    if elapsed >= DURATION then
        finished = true

        return true
    end

    return false
end


return Climb :: StateDefinition