export type InputType = Enum.KeyCode | Enum.UserInputType

export type StateDefinition = {
    transitions: { [string]: (PlayerFlags) -> boolean },
    enter: () -> (),
    exit: () -> (),
    metadata: { autoExit: { delay: number, callback: (flags: PlayerFlags) -> () }? }
}

export type PlayerFlags = {
    i_move: boolean,
    i_run: boolean,
    i_crouch: boolean,
    a_slide: boolean
}

--[[ prefix: i_move, i_run, i_crouch, a_slide

i - input
a - action

]]


return nil