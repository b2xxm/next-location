--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local StateMachine = require(shared.StateMachine)
local Input = require(client.Input)
local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Types = require(shared.Types)


type StateInput = Types.StateInput
type InputType = Types.InputType


local player: Player = Players.LocalPlayer
local playerGui: PlayerGui = player.PlayerGui

local runKey: InputType = Enum.KeyCode.LeftShift -- allow user mapping
local crouchKey: InputType = Enum.KeyCode.LeftControl -- allow user mapping
local moveKeys: { InputType } = { Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D }


local flags: StateInput = { move = false, run = false, crouch = false }
local keysDown: { [InputType]: boolean } = {}


local Player = {}


function Player.initialise(): ()
    local function moving(input: InputObject): ()
        if input.UserInputState == Enum.UserInputState.Begin then
            keysDown[input.KeyCode] = true

        elseif input.UserInputState == Enum.UserInputState.End then
            keysDown[input.KeyCode] = false
        end

        local moving = false

        for key, isDown in keysDown do
            moving = moving or isDown
        end

        flags.move = moving

        StateMachine.update(flags)
    end

    local function run(input: InputObject): ()
        flags.run = input.UserInputState == Enum.UserInputState.Begin

        StateMachine.update(flags)
    end

    local function crouch(input: InputObject): ()
        flags.crouch = input.UserInputState == Enum.UserInputState.Begin

        StateMachine.update(flags)
    end
    
    Animation.initialise(player)
    StateMachine.initialise()

    for _, key in moveKeys do
        keysDown[key] = false
    end

    Input.register("Movement", moving, table.unpack(moveKeys))
    Input.register("RunKeyDown", run, runKey)
    Input.register("CrouchKeyDown", crouch, crouchKey)
end


function Player.getInterface(name: string): ScreenGui
    return playerGui:FindFirstChild(name) :: ScreenGui
end


function Player.toggleMovement(enabled: boolean): ()
    flags.move = false
    flags.crouch = false

    Input.toggle("Movement", enabled)
    Input.toggle("CrouchKeyDown", enabled)

    Character.setWalkspeed(0)
    StateMachine.update(flags)
end


return Player