--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared


local Types = require(shared.Types)


type StateInput = Types.StateInput
type StateDefinition = Types.StateDefinition


local states:{ [string]: StateDefinition } = {
    Idle = require(script.Idle),
    Walk = require(script.Walk),
    Run = require(script.Run),
    Crouch = require(script.Crouch),
    Sneak = require(script.Sneak)
}


local currentState: StateDefinition = states["Idle"]


local StateMachine = {}


function StateMachine.update(input: StateInput): StateDefinition
    local options = currentState.transitions

    for toState, callback in options do
        local canTransition = callback(input)

        if not canTransition then
            continue
        end
        
        currentState.exit()
        currentState = states[toState]
        currentState.enter()

        break
    end

    return currentState
end


return StateMachine