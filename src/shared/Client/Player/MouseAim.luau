--!strict

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")


local prefabs = ReplicatedStorage.Prefabs


local FOOT_OFFSET: number = 3

local player: Player = Players.LocalPlayer
local camera: Camera = Workspace.CurrentCamera

local raycastParams: RaycastParams = RaycastParams.new()
raycastParams.RespectCanCollide = false
raycastParams.FilterType = Enum.RaycastFilterType.Include

local mousePlanePrefab: BasePart = prefabs.MouseAim:FindFirstChild("Plane")


local character: Model = nil
local plane: BasePart = nil


local MouseAim = {}


local function characterAdded(newCharacter: Model): ()
    if plane then
        plane:Destroy()
    end
    
    character = newCharacter
    plane = mousePlanePrefab:Clone()
    plane.Parent = Workspace

    raycastParams.FilterDescendantsInstances = { plane }

    local weld = plane:FindFirstChildOfClass("WeldConstraint") :: WeldConstraint
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart") :: BasePart

    plane.Position = humanoidRootPart.Position - Vector3.yAxis * FOOT_OFFSET
    weld.Part1 = humanoidRootPart
    weld.Enabled = true
end


local function update(_deltaTime: number): ()
    local position = UserInputService:GetMouseLocation()
    local ray = camera:ViewportPointToRay(position.X, position.Y)
    local result = Workspace:Raycast(ray.Origin, ray.Direction * 100, raycastParams)

    if not result then
        return
    end

    MouseAim.mouseMoved(result.Position)
end


function MouseAim.initialise(): ()
    characterAdded(player.Character :: Model)
    
    player.CharacterAdded:Connect(characterAdded)
end


function MouseAim.mouseMoved(target: Vector3): ()
    if not character.Parent then
        return
    end

    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart
    local direction = target - rootPart.Position
    local xzDirection = Vector3.new(direction.X, 0, direction.Z)

    rootPart.CFrame = CFrame.lookAlong(rootPart.Position, xzDirection)
end


function MouseAim.toggle(enabled: boolean): ()
    if enabled then
        RunService:BindToRenderStep("DirectionUpdate", Enum.RenderPriority.Last.Value, update)
    else
        RunService:UnbindFromRenderStep("DirectionUpdate")
    end
end


return MouseAim
