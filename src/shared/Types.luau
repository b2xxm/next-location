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
    a_thief: boolean,
    a_kong: boolean,
    a_fall: boolean,
    a_land: boolean
}

--[[ prefix

i - input
a - action

]]


return nil