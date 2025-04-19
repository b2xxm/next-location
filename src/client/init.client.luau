local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Input = require(client.Input)
local Camera = require(client.Camera)
local MouseAim = require(client.MouseAim)
local Stratagem = require(client.Stratagem)
local HideWalls = require(client.HideWalls)
local Player = require(client.Player)


Input.initialise()
Player.initialise()
Camera.initialise()
MouseAim.initialise()
Stratagem.initialise()

Stratagem.load({ "TEST", "SEQUENCE 2", "SCAN" }) -- temporary
HideWalls.load(Workspace.Map)