local socket = require("socket")
local runner = require('core.runner')
local parser = require('core.parser')
local web = require('core.web')

local function serve_file(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

local function get_tasks_list()
    local tasks = runner.list()
    local result = {}
    result._array = true
    for _, name in ipairs(tasks) do
        table.insert(result, name)
    end
    return result
end

-- FIX: Override both print() AND io.write() so all output is captured.
-- Previously only io.write was overridden, but Lua's print() goes directly
-- to stdout and bypasses io.write — so task output was never captured.
local function run_task_sync(task_name)
    local output_buffer = {}

    -- Save originals
    local original_print = print
    local original_write = io.write

    -- Override print to capture output
    print = function(...)
        local args = {...}
        local parts = {}
        for i = 1, #args do
            table.insert(parts, tostring(args[i]))
        end
        local line = table.concat(parts, "\t") .. "\n"
        table.insert(output_buffer, line)
        original_write(line)
    end

    -- Override io.write to capture output
    io.write = function(...)
        local args = {...}
        for i = 1, #args do
            table.insert(output_buffer, tostring(args[i]))
        end
        original_write(...)
    end

    local ok, err = pcall(function()
        runner.run(task_name)
    end)

    -- Restore originals
    print = original_print
    io.write = original_write

    return {
        success = ok,
        output = table.concat(output_buffer),
        error = ok and "" or tostring(err)
    }
end

local function handle_request(client, request_line, headers, body)
    local req = web.parse_request(request_line)
    local path = req.path or "/"

    -- Serve the dashboard HTML
    if path == "/" then
        local content = serve_file("index.html")
        if content then
            web.send_response(client, 200, { ["Content-Type"] = "text/html" }, content)
        else
            web.send_response(client, 404, { ["Content-Type"] = "text/plain" }, "index.html not found")
        end

    -- List all tasks
    elseif path == "/api/tasks" then
        local tasks = get_tasks_list()
        local response = web.json_encode({ tasks = tasks })
        web.send_response(client, 200, { ["Content-Type"] = "application/json" }, response)

    -- Run a task
    elseif path == "/api/run" then
        if req.method ~= "POST" then
            web.send_response(client, 405, { ["Content-Type"] = "text/plain" }, "Method Not Allowed")
            return
        end

        local data = web.json_decode(body)
        local task_name = data and data.task

        if not task_name then
            web.send_response(client, 400, { ["Content-Type"] = "application/json" },
                web.json_encode({ success = false, error = "Missing task name" }))
            return
        end

        local result = run_task_sync(task_name)
        local response = web.json_encode({
            success = result.success,
            output  = result.output,
            error   = result.error
        })
        web.send_response(client, 200, { ["Content-Type"] = "application/json" }, response)

    else
        web.send_response(client, 404, { ["Content-Type"] = "text/plain" }, "Not Found")
    end
end

local function start_server(host, port)
    parser.load_tasks(runner)

    local server = socket.bind(host, port)
    if not server then
        error("Failed to bind to " .. host .. ":" .. port)
    end
    server:settimeout(1)

    io.write("\n╔══════════════════════════════════╗\n")
    io.write("║        luarun  server            ║\n")
    io.write("╠══════════════════════════════════╣\n")
    io.write("║  http://" .. host .. ":" .. port .. "          ║\n")
    io.write("║  Press Ctrl+C to stop            ║\n")
    io.write("╚══════════════════════════════════╝\n\n")

    while true do
        local client = server:accept()
        if client then
            client:settimeout(5)
            local request_line = client:receive()
            if request_line then
                local headers = web.parse_headers(client)
                local body = web.read_body(client, headers)
                handle_request(client, request_line, headers, body)
            end
            client:close()
        end
    end
end

local host = arg[1] or "localhost"
local port = tonumber(arg[2] or 8080)
start_server(host, port)
