--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local TweenUtils = require(client.TweenUtils)


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


function Character.toggleForwardVelocity(enabled: boolean, givenSpeed: number?): ()
    local character = player.Character :: Model
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    local velocity = rootPart:WaitForChild("LinearVelocity") :: LinearVelocity
    local speed = givenSpeed or 0

    velocity.VectorVelocity = rootPart.CFrame.LookVector * speed
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


function Character.isTouching(part: BasePart): boolean
    local parts = workspace:GetPartsInPart(part, overlapParams)

    return #parts ~= 0
end


function Character.moveTo(position: Vector3, duration: number): ()
    local character = player.Character :: Model
    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    local info = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local goal = { CFrame = CFrame.new(position) * rootPart.CFrame.Rotation }

    rootPart.Anchored = true

    local tween = TweenUtils.create(rootPart, info, goal)
    tween:Play()
    tween.Completed:Wait()

    rootPart.Anchored = false
end


return Character