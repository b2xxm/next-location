local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Input = require(client.Input)
local Camera = require(client.Camera)
local MouseAim = require(client.MouseAim)
local Stratagem = require(client.Stratagem)


Input.initialise()
Camera.initialise()
MouseAim.initialise()
Stratagem.initialise()

Stratagem.load({ "TEST", "SEQUENCE 2", "SCAN" }) -- temporary