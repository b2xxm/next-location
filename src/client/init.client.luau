local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local Camera = require(client.Camera)
local MouseAim = require(client.MouseAim)


Camera.initialise()