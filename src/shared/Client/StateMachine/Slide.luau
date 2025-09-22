local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Config = require(shared.Config)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local DURATION: number = Config.locomotion.duration.slide
local SLIDE_SPEED: number = Config.locomotion.speed.slide
local RAY_LENGTH: number = Config.locomotion.slideBreakRayLength

local player: Player = Players.LocalPlayer
local waistOffset = Config.offset.waist

local raycastParams: RaycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude


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
    end,
    Fall = function(flags: PlayerFlags): boolean
        return flags.a_fall
    end
}


function Slide.enter(): ()
    elapsed = 0
    raycastParams.FilterDescendantsInstances = { player.Character :: Model }

    local direction = Character.getLookDirection()

    Character.toggleVelocity(true, direction, SLIDE_SPEED)
    Animation.play("Slide")
end


function Slide.exit(): ()
    Character.toggleVelocity(false)
    Animation.stop("Slide")
end


function Slide.update(deltaTime: number, flags: PlayerFlags): boolean
    elapsed += deltaTime

    if elapsed >= DURATION then
        flags.a_slide = false

        return true
    end

    local position = Character.getPosition()
    local direction = Character.getLookDirection()
    local result = Workspace:Raycast(position + waistOffset, direction * RAY_LENGTH, raycastParams)

    if result then
        local object = result.Instance

        if object.CanCollide then
            flags.a_slide = false
        end

        return object.CanCollide
    end

    return false
end


return Slide :: StateDefinition