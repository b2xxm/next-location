--!strict

local Players = game:GetService("Players")


local player: Player = Players.LocalPlayer


local velocityPrefab = Instance.new("LinearVelocity")
velocityPrefab.ForceLimitsEnabled = false
velocityPrefab.Enabled = false


local Character = {}


local function characterAdded(character: Model): ()
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    local attachment = Instance.new("Attachment")
    attachment.Parent = rootPart

    local velocity = velocityPrefab:Clone()
    velocity.Attachment0 = attachment
    velocity.Parent = rootPart
end


function Character.initialise(): ()
    local character = player.Character or player.CharacterAdded:Wait() :: Model

    characterAdded(character)

    player.CharacterAdded:Connect(characterAdded)
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

    local velocity = rootPart:WaitForChild("LinearVelocity") :: LinearVelocity
    velocity.VectorVelocity = rootPart.CFrame.LookVector * speed
    velocity.Enabled = true
end


function Character.disableForwardVelocity(): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    humanoid.AutoRotate = true
    
    local velocity = rootPart:WaitForChild("LinearVelocity") :: LinearVelocity
    velocity.Enabled = false
end


function Character.getLookDirection(): Vector3
    local character = player.Character :: Model
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart
    local direction = rootPart.CFrame.LookVector

    return direction
end


return Character