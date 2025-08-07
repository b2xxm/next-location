local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Config = require(shared.Config)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local DURATION: number = Config.locomotion.duration.scale
local START_SCALE_DISTANCE: number = Config.locomotion.triggerDistance.scaleStart
local RUN_SPEED: number = Config.locomotion.speed.run
local CHARACTER_HEIGHT: number = Config.offset.height

local scaleObjects: { Instance } = CollectionService:GetTagged("ScaleObject")

local raycastParams: RaycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = scaleObjects
raycastParams.FilterType = Enum.RaycastFilterType.Include


local elapsed: number = 0
local started: boolean = false


local Scale = {}
Scale.transitions = {
    Hang = function(flags: PlayerFlags): boolean
        return not flags.a_scale
    end
}


function Scale.enter(): ()
    elapsed = 0
    started = false

    Animation.play("Run")

    local direction = Character.getLookDirection()

    Character.setWalkspeed(0)
    Character.toggleVelocity(true, direction, RUN_SPEED)
end


function Scale.exit(): ()
    Animation.stop("Scale")
    Character.toggleVelocity(false)
end


function Scale.update(deltaTime: number, flags: PlayerFlags): boolean
    if started then
        elapsed += deltaTime

        if elapsed >= DURATION then
            flags.a_scale = false

            return true
        end

        return false
    end

    local position = Character.getPosition()
    local direction = Character.getLookDirection()
    local result = Workspace:Raycast(position, direction * START_SCALE_DISTANCE, raycastParams)

    if not result then
        return false
    end
    
    started = true

    Animation.stop("Run")
    Animation.play("Scale")

    local up = Vector3.yAxis
    local height = result.Instance.Size.Y

    Character.toggleVelocity(true, up, (height - CHARACTER_HEIGHT) / DURATION)

    return false
end


return Scale :: StateDefinition