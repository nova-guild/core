
export type FsMetadata = {
    kind: "file" | "dir",
    exists: boolean,
    createdAt: number,
    modifiedAt: number,
    accessedAt: number,
    permissions: {
        readOnly: boolean
    }
}

export type FsAdapter = {
    isFile: (path: string) -> boolean,
    readFile: (path: string) -> string,
    writeFile: (path: string, contents: buffer | string) -> (),
    isDir: (path: string) -> boolean,
    readDir: (path: string) -> {string},
    metadata: (path: string) -> FsMetadata
}

return {}
