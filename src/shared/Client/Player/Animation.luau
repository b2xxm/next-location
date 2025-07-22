--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")


local player: Player = Players.LocalPlayer


local animations: { [string]: AnimationTrack } = {}


local Animation = {}


function Animation.initialise(): ()
    local character = player.Character :: Model

    local humanoid = character:WaitForChild("Humanoid") :: Humanoid
    local animator = humanoid:WaitForChild("Animator") :: Animator

    for _, animation in ReplicatedStorage.Animations:GetChildren() do
        local track = animator:LoadAnimation(animation)

        animations[animation.Name] = track
    end
end


function Animation.play(name: string): ()
    local track = animations[name]

    if not track then
        warn(`track '{name}' doens't exist`)

        return
    end

    track:Play()
end


function Animation.stop(name: string): ()
    local track = animations[name]

    if not track then
        warn(`track '{name}' doens't exist`)

        return
    end
    
    track:Stop()
end


return Animation