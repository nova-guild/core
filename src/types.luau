-- TODO: Enhance the types 

export type Next = () -> ()

export type Nova = {
    --[[
        Starts the server
    ]]
    listen: (self: Nova, handler: () -> ()) -> ()
}

-- Middleware
export type Middleware = (req: Request | RequestWith<any>, next: Next) -> ResponsePayload?
export type Handler = (req: Request | RequestWith<any>) -> any

-- Request
export type RequestWith<T> = {
    method: string,
    path: string,
    body: {any},
    headers: {
        [string]: string?
    }?,
    params: T,
    query: T
}

export type Request = RequestWith<{ [string]: any }>

-- Response
export type ResponseOptions = {
    status: number?,
    headers: { [string]: string }?
}

export type ResponsePayload = {
    body: string,
    config: ResponseOptions
}

export type Response = {
    --[[
        Respond with a string
    ]]
    send: (body: string, config: ResponseOptions?) -> ResponsePayload,

    --[[
        Respond with a json
    ]]
    json: (body: {any}, config: ResponseOptions?) -> ResponsePayload,

    --[[
        Respond with an html
    ]]
    html: (body: string, config: ResponseOptions?) -> ResponsePayload,

    --[[
        Respond with a css
    ]]
    js: (body: string, config: ResponseOptions?) -> ResponsePayload,

    --[[
        Respond with a js
    ]]
    css: (body: string, config: ResponseOptions?) -> ResponsePayload,
}


return {}
