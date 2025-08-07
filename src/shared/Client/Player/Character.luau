--!strict

local Players = game:GetService("Players")


local player: Player = Players.LocalPlayer

local velocityPrefab: LinearVelocity = Instance.new("LinearVelocity")
velocityPrefab.ForceLimitsEnabled = false
velocityPrefab.Enabled = false

local overlapParams: OverlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include


local Character = {}


local function characterAdded(character: Model): ()
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    local attachment = Instance.new("Attachment")
    attachment.Parent = rootPart

    local velocity = velocityPrefab:Clone()
    velocity.Attachment0 = attachment
    velocity.Parent = rootPart

    overlapParams.FilterDescendantsInstances = { character }
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


function Character.toggleVelocity(enabled: boolean, givenDirection: Vector3?, givenSpeed: number?): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    local velocity = rootPart:WaitForChild("LinearVelocity") :: LinearVelocity
    local speed = givenSpeed or 0
    local direction = givenDirection or Vector3.zero

    velocity.VectorVelocity = direction * speed
    velocity.Enabled = enabled
    humanoid.AutoRotate = not enabled
end


function Character.getLookDirection(): Vector3
    local character = player.Character :: Model
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart
    local direction = rootPart.CFrame.LookVector

    return direction
end


function Character.getPosition(): Vector3
    local character = player.Character :: Model
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    return rootPart.Position
end


return Character