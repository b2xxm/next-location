local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local DURATION: number = 0.7
local VAULT_SPEED: number = 6

local vaultObjects: { BasePart } = CollectionService:GetTagged("VaultObject")


local elapsed: number = 0


local ThiefVault = {}
ThiefVault.transitions = {
    Walk = function(flags: PlayerFlags): boolean
        return flags.i_move and not flags.i_run and not flags.a_vault
    end,
    Run = function(flags: PlayerFlags): boolean
        return flags.i_move and flags.i_run and not flags.a_vault
    end,
    Idle = function(flags: PlayerFlags): boolean
        return not flags.i_move and not flags.a_vault
    end
}


function ThiefVault.enter(): ()
    elapsed = 0

    for _, part in vaultObjects do
        part.CanCollide = false
    end

    Character.toggleForwardVelocity(true, VAULT_SPEED)
    Animation.play("Thief")
end


function ThiefVault.exit(): ()
    Character.toggleForwardVelocity(false)
    Animation.stop("Thief")

    for _, part in vaultObjects do
        part.CanCollide = true
    end
end


function ThiefVault.update(deltaTime: number, flags: PlayerFlags): boolean
    elapsed += deltaTime

    if elapsed >= DURATION then
        flags.a_vault = false

        return true
    end

    return false
end


return ThiefVault