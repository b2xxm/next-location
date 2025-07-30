local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local DURATION: number = 0.4
local VAULT_SPEED: number = 22
local START_VAULT_DISTANCE: number = 3.5
local RAY_LENGTH: number = 10

local waistOffset: Vector3 = -Vector3.yAxis

local vaultObjects: { Instance } = CollectionService:GetTagged("VaultObject")

local raycastParams: RaycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = vaultObjects
raycastParams.FilterType = Enum.RaycastFilterType.Include


local elapsed: number = 0
local started: boolean = false


local KongVault = {}
KongVault.transitions = {
    Walk = function(flags: PlayerFlags): boolean
        return flags.i_move and not flags.i_run and not flags.a_kong
    end,
    Run = function(flags: PlayerFlags): boolean
        return flags.i_move and flags.i_run and not flags.a_kong
    end,
    Idle = function(flags: PlayerFlags): boolean
        return not flags.i_move and not flags.a_kong
    end
}


function KongVault.enter(): ()
    elapsed = 0
    started = false

    for _, part in vaultObjects do
        part.CanCollide = false
    end

    Character.toggleForwardVelocity(true, VAULT_SPEED)
    Animation.play("Run")
end


function KongVault.exit(): ()
    Character.toggleForwardVelocity(false)
    Animation.stop("Kong")

    for _, part in vaultObjects do
        part.CanCollide = true
    end
end


function KongVault.update(deltaTime: number, flags: PlayerFlags): boolean
    if started then
        elapsed += deltaTime

        if elapsed >= DURATION then
            flags.a_kong = false

            return true
        end

        return false
    end

    local position = Character.getPosition()
    local direction = Character.getLookDirection()
    local result = Workspace:Raycast(position + waistOffset, direction * RAY_LENGTH, raycastParams)

    if not result then
        return false
    end

    local hitPosition = result.Position

    if (position - hitPosition).Magnitude > START_VAULT_DISTANCE then
        return false
    end
    
    started = true

    Animation.stop("Run")
    Animation.play("Kong")

    return false
end


return KongVault