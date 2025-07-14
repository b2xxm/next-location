local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Input = require(client.Input)
local Stratagem = require(client.Stratagem)
local HideWalls = require(client.HideWalls)
local Player = require(client.Player)


Input.initialise()
Player.initialise()
Stratagem.initialise()

-- temporary
Stratagem.load({ "TEST", "SEQUENCE 2", "SCAN" })
HideWalls.load(Workspace.Map)