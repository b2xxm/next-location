--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local prefabs = ReplicatedStorage.Prefabs


local SMOOTHING_FACTOR: number = 0.05
local UPDATE_NAME: string = "CameraUpdate"
local UPDATE_PRIORITY: number = Enum.RenderPriority.Camera.Value
local TARGET_FRAME_RATE: number = 60


local character: Model = nil
local focusPart: Part = nil
local camera: Camera = workspace.CurrentCamera
local offset: Vector3 = Vector3.new(-7, 15, -7)


local Camera = {}


function Camera.initialise(): ()
	local player = Players.LocalPlayer
    local focusPartPrefab = prefabs.Camera:WaitForChild("FocusPart")
	
	character = player.Character or player.CharacterAdded:Wait()
	focusPart = focusPartPrefab:Clone()
	
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
	camera.CFrame = CFrame.lookAt(focusPart.Position + offset, focusPart.Position)
end


function Camera.refresh(newCharacter: Model): ()
	local head = newCharacter:WaitForChild("Head") :: BasePart
	
	character = newCharacter
	focusPart.Position = head.Position
	
	camera.CameraType = Enum.CameraType.Scriptable
end


return Camera
