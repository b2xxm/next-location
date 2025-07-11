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


type PlayerFlags = Types.PlayerFlags
type InputType = Types.InputType


local player: Player = Players.LocalPlayer
local playerGui: PlayerGui = player.PlayerGui

local runKey: InputType = Enum.KeyCode.LeftShift
local crouchKey: InputType = Enum.KeyCode.Space
local moveKeys: { InputType } = { Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D }

local counterMoveKeys: { [InputType]: InputType } = {
    [moveKeys[1]] = moveKeys[3],
    [moveKeys[2]] = moveKeys[4],
    [moveKeys[3]] = moveKeys[1],
    [moveKeys[4]] = moveKeys[2],
}


local flags: { [string]: boolean } = {}
local moveKeysDown: { [InputType]: boolean } = {}


local Player = {}


local function updateState(): ()
    local newState = StateMachine.update(flags)

    if not newState then
        return
    end

    local autoExit = newState.metadata.autoExit
    
    if autoExit then
        local function automatic(): ()
            autoExit.callback(flags)
            StateMachine.update(flags)
        end

        task.delay(autoExit.delay, automatic)
    end
end


function Player.initialise(): ()
    local function move(input: InputObject): ()
        if input.UserInputState == Enum.UserInputState.Begin then
            moveKeysDown[input.KeyCode] = true

        elseif input.UserInputState == Enum.UserInputState.End then
            moveKeysDown[input.KeyCode] = false
        end

        local moving = false
        local counteracting = false
        local keysDown = 0

        for key, isDown in moveKeysDown do
            moving = moving or isDown
            counteracting = counteracting or (moveKeysDown[counterMoveKeys[key]] and isDown)
            keysDown += if isDown then 1 else 0
        end

        if counteracting then
            moving = not (keysDown % 2 == 0)
        end

        flags.i_move = moving

        updateState()
    end

    local function run(input: InputObject): ()
        flags.i_run = input.UserInputState == Enum.UserInputState.Begin

        updateState()
    end

    local function crouch(input: InputObject): ()
        local crouching = input.UserInputState == Enum.UserInputState.Begin
        flags.i_crouch = crouching

        if not flags.a_slide then
            flags.a_slide = crouching and flags.i_run
        end

        updateState()
    end
    
    Animation.initialise(player)
    StateMachine.initialise()

    for _, key in moveKeys do
        moveKeysDown[key] = false
    end

    Input.register("Movement", move, table.unpack(moveKeys))
    Input.register("RunKeyDown", run, runKey)
    Input.register("CrouchKeyDown", crouch, crouchKey)
end


function Player.getInterface(name: string): ScreenGui
    return playerGui:WaitForChild(name) :: ScreenGui
end


function Player.toggleMovement(enabled: boolean): ()
    flags.i_move = false
    flags.i_crouch = false

    Input.toggle("Movement", enabled)
    Input.toggle("CrouchKeyDown", enabled)

    updateState()
    Character.setWalkspeed(0)
end


Character.initialise()

-- DEBUG
local DebugMenu = Player.getInterface("Debug")
local prefab = DebugMenu:FindFirstChild("Prefab", true) :: Frame

local internal: PlayerFlags = { i_move = false, i_run = false, i_crouch = false, a_slide = false }
local stateValues = {}

for state, value in internal do
    local new = prefab:Clone()
    local stateLabel = new:FindFirstChild("State") :: TextLabel
    local valueLabel = new:FindFirstChild("Value") :: TextLabel
    new.Parent = prefab.Parent

    stateLabel.Text = state :: string
    valueLabel.Text = tostring(value)

    stateValues[state] = valueLabel
end

setmetatable(flags, {
    __index = internal,
    __newindex = function(_, k, v)
        internal[k] = v
        stateValues[k].Text = tostring(v)
    end
})

prefab:Destroy()
-- END DEBUG

return Player