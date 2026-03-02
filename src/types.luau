-- Generic variant: use when you need typed params (e.g. Request<{ id: string }>)
export type RequestWith<T> = {
    path: string,
    body: {any},
    headers: {any},
    params: T,
    query: T
}

export type Request = RequestWith<{any}>

export type ResponseBody = {any} | string

export type ResponseOptions = {
    status: number?,
    isHtml: boolean?
}

export type NovaInstance = {
    listen: (self: NovaInstance, callback: () -> ()) -> ()
}

export type Next = (req: Request?) -> ()

return nil