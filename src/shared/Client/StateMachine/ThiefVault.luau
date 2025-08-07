local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Config = require(shared.Config)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local DURATION: number = Config.locomotion.duration.thief
local VAULT_SPEED: number = Config.locomotion.speed.thief

local vaultObjects: { Instance } = CollectionService:GetTagged("VaultObject")


local elapsed: number = 0


local ThiefVault = {}
ThiefVault.transitions = {
    Walk = function(flags: PlayerFlags): boolean
        return flags.i_move and not flags.i_run and not flags.a_thief
    end,
    Run = function(flags: PlayerFlags): boolean
        return flags.i_move and flags.i_run and not flags.a_thief
    end,
    Idle = function(flags: PlayerFlags): boolean
        return not flags.i_move and not flags.a_thief
    end
}


function ThiefVault.enter(): ()
    elapsed = 0

    for _, part in vaultObjects do
        part.CanCollide = false
    end

    local direction = Character.getLookDirection()

    Character.toggleVelocity(true, direction, VAULT_SPEED)
    Animation.play("Thief")
end


function ThiefVault.exit(): ()
    Character.toggleVelocity(false)
    Animation.stop("Thief")

    for _, part in vaultObjects do
        part.CanCollide = true
    end
end


function ThiefVault.update(deltaTime: number, flags: PlayerFlags): boolean
    elapsed += deltaTime

    if elapsed >= DURATION then
        flags.a_thief = false

        return true
    end

    return false
end


return ThiefVault :: StateDefinition