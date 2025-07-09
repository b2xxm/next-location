export type InputType = Enum.KeyCode | Enum.UserInputType

-- States
export type StateDefinition = {
    transitions: { [string]: (StateInput) -> boolean },
    enter: () -> (),
    exit: () -> (),
    metadata: { autoExit: { delay: number, callback: (input: StateInput) -> () }? }
}

export type StateInput = {
    move: boolean,
    run: boolean,
    crouch: boolean,
    slide: boolean
}


return nil