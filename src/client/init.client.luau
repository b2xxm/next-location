local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Input = require(client.Input)
local Camera = require(client.Camera)
local MouseAim = require(client.MouseAim)
local Stratagems = require(client.Stratagems)


Input.initialise()
Camera.initialise()
MouseAim.initialise()
Stratagems.initialise()

Stratagems.load({ 1, 2, 3 }) -- temporary