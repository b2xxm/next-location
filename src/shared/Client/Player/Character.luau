--!strict

local Players = game:GetService("Players")


local player: Player = Players.LocalPlayer


local Character = {}


function Character.initialise(): ()
    local character = player.Character or player.CharacterAdded:Wait() :: Model
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    local attachment = Instance.new("Attachment")
    attachment.Parent = rootPart

    local velocity = Instance.new("LinearVelocity")
    velocity.ForceLimitsEnabled = false
    velocity.Attachment0 = attachment
    velocity.Enabled = false
    velocity.Name = "SlideVelocity"
    velocity.Parent = rootPart
end


function Character.setWalkspeed(speed: number): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid

    humanoid.WalkSpeed = speed
end


function Character.enableSlideVelocity(): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    humanoid.AutoRotate = false

    local velocity = rootPart:WaitForChild("SlideVelocity") :: LinearVelocity
    velocity.VectorVelocity = rootPart.CFrame.LookVector * 22 -- arbitrary
    velocity.Enabled = true
end


function Character.disableSlideVelocity(): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    humanoid.AutoRotate = true
    
    local velocity = rootPart:WaitForChild("SlideVelocity") :: LinearVelocity
    velocity.Enabled = false
end


return Character