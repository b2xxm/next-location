--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")


local shared = ReplicatedStorage.Shared


local Types = require(shared.Types)


type PlayerFlags = Types.PlayerFlags
type StateDefinition = Types.StateDefinition


local states:{ [string]: StateDefinition } = {
    Idle = require(script.Idle),
    Walk = require(script.Walk),
    Run = require(script.Run),
    Crouch = require(script.Crouch),
    Sneak = require(script.Sneak),
    Slide = require(script.Slide)
}


local currentState: string = nil


local StateMachine = {}


local function transition(toState: string): ()
    local state = states[currentState]
    state.exit()

    currentState = toState

    local newState = states[currentState]
    newState.enter()
end


function StateMachine.initialise(): ()
    currentState = "Idle"

    local state = states[currentState]
    state.enter()
end


function StateMachine.update(flags: PlayerFlags): StateDefinition?
    for state, canTransition in states[currentState].transitions do
        if not canTransition(flags) then
            continue
        end

        transition(state)

        return states[state]
    end

    return
end


return StateMachine