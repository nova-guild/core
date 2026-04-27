-- nova/src/libs/process/types.luau
export type ProcessOptions = {
    cwd: string?,
    env: { [string]: string }?,
    shell: (boolean | string)?,
    stdin: ("inherit" | "pipe" | "ignore")?,
    stdout: ("inherit" | "pipe" | "ignore")?,
    stderr: ("inherit" | "pipe" | "ignore")?,
}

export type ProcessChild = {
    pid: number,
    stdin: any?,
    stdout: any?,
    stderr: any?,
    wait: (self: ProcessChild) -> { ok: boolean, code: number },
    kill: (self: ProcessChild) -> { ok: boolean, code: number },
}

export type ProcessAdapter = {
    cwd: string,
    env: { [string]: string? },
    create: (exec: string, args: { string }?, opts: ProcessOptions?) -> ProcessChild?,
    exit: (number) -> ()
}

return {}