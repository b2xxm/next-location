--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")


local shared = ReplicatedStorage.Shared
local prefabs = ReplicatedStorage.Prefabs


local Config = require(shared.Config)


local player: Player = Players.LocalPlayer

local SMOOTHING_FACTOR: number = Config.camera.smoothFactor
local TARGET_FRAME_RATE: number = Config.camera.targetFrameRate

local camera: Camera = Workspace.CurrentCamera
local offset: Vector3 = Config.camera.offset


local character: Model = nil
local focusPart: Part = nil


local Camera = {}


function Camera.initialise(): ()
    local focusPartPrefab = prefabs.Camera:WaitForChild("FocusPart")
	
	character = player.Character or player.CharacterAdded:Wait()
	focusPart = focusPartPrefab:Clone()
	
	focusPart.Parent = Workspace
	
	Camera.refresh(character)

	player.CharacterAdded:Connect(Camera.refresh)
	RunService:BindToRenderStep("CameraUpdate", Enum.RenderPriority.Camera.Value, Camera.update)
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
