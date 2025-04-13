--!strict

local Players = game:GetService("Players")


local DEFAULT_WALKSPEED: number = 16

local player: Player = Players.LocalPlayer
local playerGui: PlayerGui = player.PlayerGui


local Player = {}


function Player.getInterface(name: string): ScreenGui
    return playerGui:FindFirstChild(name) :: ScreenGui
end


function Player.toggleMovement(enabled: boolean): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid

    if enabled then
        humanoid.WalkSpeed = DEFAULT_WALKSPEED

        return
    end

    humanoid.WalkSpeed = 0
end


return Player