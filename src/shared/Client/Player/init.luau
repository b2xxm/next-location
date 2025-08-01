--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")


local shared = ReplicatedStorage.Shared
local client = shared.Client


local StateMachine = require(shared.StateMachine)
local Input = require(client.Input)
local Animation = require(client.Player.Animation)
local Character = require(client.Player.Character)
local Camera = require(client.Player.Camera)
local MouseAim = require(client.Player.MouseAim)
local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type InputType = Types.InputType


local THIEF_LOOK_THRESHOLD: number = math.cos(math.rad(20))
local KONG_LOOK_THRESHOLD: number = math.cos(math.rad(30))
local THIEF_TRIGGER_DISTANCE: number = 1
local KONG_TRIGGER_DISTANCE: number = 12
local KONG_MINIMUM_DISTANCE: number = 3

local player: Player = Players.LocalPlayer
local playerGui: PlayerGui = player.PlayerGui

local runKey: InputType = Enum.KeyCode.LeftShift
local crouchKey: InputType = Enum.KeyCode.Space
local moveKeys: { InputType } = { Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D }

local counterMoveKeys: { [InputType]: InputType } = {
    [moveKeys[1]] = moveKeys[3],
    [moveKeys[2]] = moveKeys[4],
    [moveKeys[3]] = moveKeys[1],
    [moveKeys[4]] = moveKeys[2]
}

local waistOffset = -Vector3.yAxis

local vaultRayParams = RaycastParams.new()
vaultRayParams.FilterDescendantsInstances = CollectionService:GetTagged("VaultObject")
vaultRayParams.FilterType = Enum.RaycastFilterType.Include


local flags: { [string]: boolean } = {}
local moveKeysDown: { [InputType]: boolean } = {}
local updateThread: thread? = nil


local Player = {}
Player.flags = flags


local function updateState(): boolean
    local newState = StateMachine.update(flags)

    if not newState then
        return false
    end

    if updateThread and coroutine.running() ~= updateThread then
        task.cancel(updateThread)

        updateThread = nil
    end

    local update = newState.update
    
    if not update then
        return true
    end

    local function tickState(callback: (deltaTime: number, flags: PlayerFlags) -> boolean): ()
        while true do
            local deltaTime = task.wait()
            local flagUpdated = callback(deltaTime, flags)

            if not flagUpdated then
                continue
            end

            local updated = updateState()

            if updated then
                updateThread = nil

                break
            end
        end
    end

    updateThread = task.spawn(tickState, update)

    return true
end


local function stateChanged(_: Enum.HumanoidStateType, current: Enum.HumanoidStateType): ()
    if current == Enum.HumanoidStateType.Freefall then
        flags.a_fall = true
        flags.a_slide = false

    elseif current == Enum.HumanoidStateType.Landed then
        flags.a_fall = false
        flags.a_land = true
    end

    updateState()
end


local function characterAdded(character: Model): ()
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid

    humanoid.StateChanged:Connect(stateChanged)
end


local function findVaultObject(position: Vector3, direction: Vector3, distance: number): BasePart?
    local result = Workspace:Raycast(position + waistOffset, direction * distance, vaultRayParams)

    if result then
        return result.Instance
    end
    
    return nil
end


function Player.initialise(): ()
    local function move(input: InputObject): ()
        moveKeysDown[input.KeyCode] = input.UserInputState == Enum.UserInputState.Begin

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
        flags.i_crouch = input.UserInputState == Enum.UserInputState.Begin

        local lookDirection = Character.getLookDirection()
        local position = Character.getPosition()

        if flags.i_crouch and not (flags.i_move and flags.i_run) and not flags.a_slide then
            local vaultObject = findVaultObject(position, lookDirection, THIEF_TRIGGER_DISTANCE)

            if vaultObject then
                local expectedDirection = vaultObject.CFrame.LookVector
                local product = lookDirection:Dot(expectedDirection)

                if math.abs(product) >= THIEF_LOOK_THRESHOLD then
                    flags.a_thief = true
                end
            end

        elseif flags.i_crouch and flags.i_move and flags.i_run then
            local vaultObject = findVaultObject(position, lookDirection, KONG_TRIGGER_DISTANCE)
            local lowerThresholdCheck = findVaultObject(position, lookDirection, KONG_MINIMUM_DISTANCE)

            if vaultObject and lowerThresholdCheck == nil and not flags.a_slide then
                local expectedDirection = vaultObject.CFrame.LookVector
                local product = lookDirection:Dot(expectedDirection)

                if math.abs(product) >= KONG_LOOK_THRESHOLD then
                    flags.a_kong = true
                else
                    flags.a_slide = true
                end
            else
                flags.a_slide = true
            end
        end

        updateState()
    end

    for _, key in moveKeys do
        moveKeysDown[key] = false
    end

    Character.initialise()
    Animation.initialise()
    StateMachine.initialise()
    Camera.initialise()
    MouseAim.initialise()

    Input.register("Movement", move, table.unpack(moveKeys))
    Input.register("RunKeyDown", run, runKey)
    Input.register("CrouchKeyDown", crouch, crouchKey)
    
    characterAdded(player.Character :: Model)

    player.CharacterAdded:Connect(characterAdded)
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

-- DEBUG
local DebugMenu = Player.getInterface("Debug")
local prefab = DebugMenu:FindFirstChild("Prefab", true) :: Frame

local internal: PlayerFlags = {
    i_move = false, i_run = false, i_crouch = false,

    a_slide = false, a_thief = false, a_kong = false,
    a_fall = false, a_land = false
}

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