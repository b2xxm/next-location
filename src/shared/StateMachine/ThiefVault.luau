local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags


local DURATION: number = 0.7


local vaultObjects: { BasePart } = CollectionService:GetTagged("VaultObject")


local ThiefVault = {}
ThiefVault.metadata = {
    autoExit = {
        delay = DURATION,
        callback = function(flags: PlayerFlags)
            flags.a_vault = false
        end
    }
}

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
    Character.enableForwardVelocity(6) -- arbitrary
    Animation.play("Thief")

    for _, part in vaultObjects do
        part.CanCollide = false
    end
end


function ThiefVault.exit(): ()
    Character.disableForwardVelocity()
    Animation.stop("Thief")

    for _, part in vaultObjects do
        part.CanCollide = true
    end
end


return ThiefVault