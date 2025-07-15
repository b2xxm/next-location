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


function Character.enableForwardVelocity(speed: number): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    humanoid.AutoRotate = false

    -- disable slide when falling state is entered.

    local velocity = rootPart:WaitForChild("SlideVelocity") :: LinearVelocity
    velocity.VectorVelocity = rootPart.CFrame.LookVector * speed
    velocity.Enabled = true
end


function Character.disableForwardVelocity(): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    humanoid.AutoRotate = true
    
    local velocity = rootPart:WaitForChild("SlideVelocity") :: LinearVelocity
    velocity.Enabled = false
end


function Character.getLookDirection(): Vector3
    local character = player.Character :: Model
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart
    local direction = rootPart.CFrame.LookVector

    return direction
end


return Character