--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")


local shared = ReplicatedStorage.Shared


local Types = require(shared.Types)


type InputType = Types.InputType
type Registry = { [string]: (input: InputObject) -> () }
type Register = { [InputType]: Registry }


local register: Register = {}
local actionStatus: { [string]: boolean } = {}


local Input = {}


local function onInput(input: InputObject, processedEvent: boolean): ()
    if processedEvent then
        return
    end

    local keyCode = if input.KeyCode ~= Enum.KeyCode.Unknown then input.KeyCode else input.UserInputType
    local registry = register[keyCode]
    
    if not registry then
        return
    end

    for name, callback in registry do
        if not actionStatus[name] then
            continue
        end

        callback(input)
    end
end


function Input.initialise(): ()
    UserInputService.InputBegan:Connect(onInput)
    UserInputService.InputEnded:Connect(onInput)
end


function Input.register(name: string, callback: (input: InputObject) -> (), ...: InputType): ()
    local keyCodes = { ... }

    if #keyCodes == 0 then
        warn("no keycode provided")

        return
    end

    if actionStatus[name] ~= nil then
        warn(`'{name}' occupies different actions`)

        return
    end

    actionStatus[name] = true
    
    for _, keyCode in keyCodes do
        if not register[keyCode] then
            register[keyCode] = {}
        end

        local registry = register[keyCode]
        
        registry[name] = callback
    end
end


function Input.toggle(name: string, enabled: boolean): ()
    if actionStatus[name] == nil then
        warn(`{name} is not registered yet`)

        return
    end

    actionStatus[name] = enabled
end


return Input