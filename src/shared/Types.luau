export type InputType = Enum.KeyCode | Enum.UserInputType

-- States
export type StateDefinition = {
    transitions: { [string]: (StateInput) -> boolean },
    enter: () -> (),
    exit: () -> ()
}

export type StateInput = {
    move: boolean,
    run: boolean,
    crouch: boolean
}


return nil