--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local prefabs = ReplicatedStorage.Prefabs


local SMOOTHING_FACTOR: number = 0.05
local UPDATE_NAME = "CameraUpdate"
local UPDATE_PRIORITY = Enum.RenderPriority.Camera.Value
local TARGET_FRAME_RATE = 60


local character: Model = nil
local focusPart: Part = nil
local camera: Camera = workspace.CurrentCamera


local Camera = {}


local function initialise(): ()
	local player = Players.LocalPlayer
    local focusPartPrefab = prefabs.Camera:WaitForChild("FocusPart")
	
	character = player.CharacterAdded:Wait()
	focusPart = focusPartPrefab:Clone()
	
	camera.CameraType = Enum.CameraType.Track
	focusPart.Parent = workspace
	
	Camera.refresh(character)

	player.CharacterAdded:Connect(Camera.refresh)
	RunService:BindToRenderStep(UPDATE_NAME, UPDATE_PRIORITY, Camera.update)
end


function Camera.update(deltaTime: number): ()
	if not character.Parent then
		return
	end
	
	local head = character:WaitForChild("Head") :: BasePart
	local alpha = 1 - math.pow(1 - SMOOTHING_FACTOR, deltaTime * TARGET_FRAME_RATE)

	focusPart.Position = focusPart.Position:Lerp(head.Position, alpha)
end


function Camera.refresh(newCharacter: Model): ()
	local head = newCharacter:WaitForChild("Head") :: BasePart
	
	character = newCharacter
	focusPart.CFrame = head.CFrame
	camera.CameraSubject = focusPart
end


initialise()


return Camera
