--!strict

local Players = game:GetService("Players")


local player: Player = Players.LocalPlayer


local Character = {}


function Character.setWalkspeed(speed: number): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid

    humanoid.WalkSpeed = speed
end


return Character