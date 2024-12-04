--!strict

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")


local player: Player = Players.LocalPlayer
local character: Model? = player.Character
local camera: Camera = workspace.CurrentCamera

local raycastParams: RaycastParams = RaycastParams.new()
raycastParams.RespectCanCollide = false
raycastParams.FilterType = Enum.RaycastFilterType.Exclude


local MouseAim = {}


local function refreshCharacter(newCharacter: Model): ()
    character = newCharacter
    raycastParams.FilterDescendantsInstances = { newCharacter }
end


local function update(_deltaTime: number): ()
    local position = UserInputService:GetMouseLocation()
    local ray = camera:ViewportPointToRay(position.X, position.Y)
    local result = workspace:Raycast(ray.Origin, ray.Direction * 100, raycastParams)

    if not result then
        return
    end

    MouseAim.mouseMoved(result.Position)
end


function MouseAim.mouseMoved(target: Vector3): ()
    if not character or not character.Parent then
        return
    end

    local rootPart = character:WaitForChild("HumanoidRootPart") :: BasePart
    local direction = target - rootPart.Position
    local xzDirection = Vector3.new(direction.X, 0, direction.Z)

    rootPart.CFrame = CFrame.lookAlong(rootPart.Position, xzDirection)
end


player.CharacterAdded:Connect(refreshCharacter)
RunService:BindToRenderStep("test", 2000, update)


return MouseAim
