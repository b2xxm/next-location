--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared
local prefabs = ReplicatedStorage.Prefabs
local client = shared.Client


local Types = require(shared.Types)
local StratagemList = require(shared.StratagemList)
local Input = require(client.Input)
local Player = require(client.Player)


type InputType = Types.InputType


local CAPACITY: number = 4
local DEFAULT_TEXT_TRANSPARENCY: number = 0.5

local characterPrefab: TextLabel = prefabs.Stratagem.Character
local templatePrefab: Frame = prefabs.Stratagem.Template

local menuKeyCode: InputType = Enum.KeyCode.LeftAlt -- allow user mapping
local activateKeyCode: InputType = Enum.KeyCode.F -- allow user mapping
local sequenceKeyCodes: { InputType } = { Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D }


local sequences: { [string]: { string }} = {}
local validSequences: { [string]: { string }} = {}
local characterIndex: number = 1
local selected: string? = nil


local Stratagem = {}


local function toggleMenu(enabled: boolean): ()
    if enabled and selected then
        return
    end

    local stratagemGui = Player.getInterface("StrategemMenu")
    local container = stratagemGui:FindFirstChild("Container") :: Frame

    Player.toggleMovement(not enabled)
    Input.toggle("StratagemSequence", enabled)

    container.Visible = enabled

    if not enabled then
        return
    end
    
    characterIndex = 1

    table.clear(validSequences)

    for key, sequence in sequences do
        validSequences[key] = sequence

        local stratagemUi = container:FindFirstChild(key) :: Frame
        local sequenceContainer = stratagemUi:FindFirstChild("Sequence") :: Frame

        for _, instance in sequenceContainer:GetChildren() do
            if not instance:IsA("TextLabel") then
                continue
            end

            instance.TextTransparency = DEFAULT_TEXT_TRANSPARENCY
        end

        stratagemUi.Visible = true
    end
end


local function sequenceInput(input: InputObject): ()
    if selected then
        return
    end

    if input.UserInputState ~= Enum.UserInputState.Begin then
        return
    end

    local stratagemGui = Player.getInterface("StrategemMenu")
    local container = stratagemGui:FindFirstChild("Container") :: Frame

    local removing = {}
    local count = 0
    local character = input.KeyCode.Name
    
    for key, sequence in validSequences do
        count += 1

        if character == sequence[characterIndex] then
            local stratagemFrame = container:FindFirstChild(key) :: Frame
            local sequenceContainer = stratagemFrame:FindFirstChild("Sequence") :: Frame

            local characterLabel = sequenceContainer:FindFirstChild(tostring(characterIndex)) :: TextLabel
            characterLabel.TextTransparency = 0

            if #sequence == characterIndex then
                selected = key
            end

            continue
        end

        table.insert(removing, key)
    end

    if #removing ~= count then
        characterIndex += 1

        for _, key in removing do
            validSequences[key] = nil

            local stratagemFrame = container:FindFirstChild(key) :: Frame
            stratagemFrame.Visible = false
        end
    end
end


function Stratagem.initialise(): ()
    local function toggleMenuInput(input: InputObject)
        if input.UserInputState == Enum.UserInputState.Begin then
            toggleMenu(true)

        elseif input.UserInputState == Enum.UserInputState.End then
            if selected then
                Input.toggle("ActivateStratagem", true)
            end

            toggleMenu(false)
        end
    end

    local function activate(input: InputObject)
        if selected == nil then
            return
        end

        print(selected, "activated")

        local stratagem = StratagemList[selected]
        stratagem.callback()

        selected = nil

        Input.toggle("ActivateStratagem", false)
    end

    Input.register("StratagemMenu", toggleMenuInput, menuKeyCode)
    Input.register("StratagemSequence", sequenceInput, table.unpack(sequenceKeyCodes))
    Input.register("ActivateStratagem", activate, activateKeyCode)

    Input.toggle("ActivateStratagem", false)
    toggleMenu(false)
end


function Stratagem.load(stratagems: { string }): ()
    if #stratagems > CAPACITY then
        error("exceeds stratagem capacity")
    end

    table.clear(sequences)
    
    local stratagemGui = Player.getInterface("StrategemMenu")
    local container = stratagemGui:FindFirstChild("Container") :: Frame

    for _, instance in container:GetChildren() do
        if not instance:IsA("Frame") then
            continue
        end

        instance:Destroy()
    end

    for _, name in stratagems do
        local stratagem = StratagemList[name]
        sequences[name] = stratagem.sequence

        local template = templatePrefab:Clone()
        local label = template:FindFirstChild("NameLabel") :: TextLabel
        template.Name = name
        label.Text = name

        local sequenceContainer = template:FindFirstChild("Sequence")

        for index, character in stratagem.sequence do
            local characterLabel = characterPrefab:Clone()
            characterLabel.Name = tostring(index)
            characterLabel.Text = character
            characterLabel.LayoutOrder = index
            characterLabel.Parent = sequenceContainer
        end

        template.Parent = container
    end
end


return Stratagem