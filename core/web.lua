local web = {}

function web.parse_request(line)
    local method, path, proto = line:match("^(%S+)%s+(%S+)%s+(%S+)")
    return { method = method, path = path, proto = proto }
end

function web.parse_headers(client)
    local headers = {}
    while true do
        local line = client:receive()
        if not line or line == "" then break end
        local name, value = line:match("^([^:]+):%s*(.+)")
        if name then
            headers[name:lower()] = value
        end
    end
    return headers
end

function web.read_body(client, headers)
    local length = tonumber(headers["content-length"] or 0)
    if length > 0 then
        return client:receive(length)
    end
    return ""
end

function web.json_encode(t)
    if type(t) == "string" then
        return '"' .. t:gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r') .. '"'
    elseif type(t) == "number" then
        return tostring(t)
    elseif type(t) == "boolean" then
        return t and "true" or "false"
    elseif type(t) == "table" then
        if t._array then
            local items = {}
            for i, v in ipairs(t) do
                table.insert(items, web.json_encode(v))
            end
            return "[" .. table.concat(items, ",") .. "]"
        else
            local items = {}
            for k, v in pairs(t) do
                if type(k) == "string" then
                    table.insert(items, web.json_encode(k) .. ":" .. web.json_encode(v))
                end
            end
            return "{" .. table.concat(items, ",") .. "}"
        end
    elseif t == nil then
        return "null"
    end
    return "null"
end

function web.json_decode(s)
    s = s:match("^%s*(.-)%s*$")
    if s:match("^%[") then
        local result = {}
        result._array = true
        local items = s:sub(2, -2):gmatch("[^,]+")
        for item in items do
            table.insert(result, web.json_decode(item))
        end
        return result
    elseif s:match("^{") then
        local result = {}
        for k, v in s:gmatch('"([^"]+)"%s*:%s*([^,}]+)') do
            result[k] = web.json_decode(v)
        end
        return result
    elseif s == "null" then
        return nil
    elseif s == "true" then
        return true
    elseif s == "false" then
        return false
    elseif tonumber(s) then
        return tonumber(s)
    else
        return s:match('^"(.*)"$') or s
    end
end

function web.send_response(client, status, headers, body)
    local status_text = {
        [200] = "OK",
        [404] = "Not Found",
        [500] = "Internal Server Error",
    }
    
    local response = "HTTP/1.1 " .. status .. " " .. (status_text[status] or "Unknown") .. "\r\n"
    response = response .. "Server: luarun/1.0\r\n"
    response = response .. "Content-Length: " .. #body .. "\r\n"
    for k, v in pairs(headers) do
        response = response .. k .. ": " .. v .. "\r\n"
    end
    response = response .. "\r\n" .. body
    
    client:send(response)
end

function web.mime_type(path)
    local ext = path:match("%.([^.]+)$")
    local types = {
        html = "text/html",
        css = "text/css",
        js = "application/javascript",
        json = "application/json",
        png = "image/png",
        jpg = "image/jpeg",
        gif = "image/gif",
        svg = "image/svg+xml",
        ico = "image/x-icon",
    }
    return types[ext] or "text/plain"
end

return web
