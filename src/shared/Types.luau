export type InputType = Enum.KeyCode | Enum.UserInputType

export type StateDefinition = {
    transitions: { [string]: (PlayerFlags) -> boolean },
    enter: () -> (),
    exit: () -> (),
    update: ((deltaTime: number, flags: PlayerFlags) -> boolean)?,
}

export type PlayerFlags = {
    i_move: boolean,
    i_run: boolean,
    i_crouch: boolean,
    a_slide: boolean,
    a_vault: boolean
}

--[[ prefix: i_move, i_run, i_crouch, a_slide

i - input
a - action

]]


return nil