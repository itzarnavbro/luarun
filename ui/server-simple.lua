local runner = require('core.runner')
local parser = require('core.parser')

local PORT = tonumber(arg[1] or 8080)

local function simple_server()
    parser.load_tasks(runner)
    
    local tasks = runner.list()
    print("\n╔════════════════════════════════════╗")
    print("║        luarun Dashboard Ready     ║")
    print("╠════════════════════════════════════╣")
    print("║  Available tasks:                 ║")
    for _, task in ipairs(tasks) do
        print("║    - " .. task)
    end
    print("╚════════════════════════════════════╝\n")
    
    print("Note: Full web dashboard requires 'socket' library")
    print("For now, use: lua main.lua <taskname>")
    print("\nExample:")
    for _, task in ipairs(tasks) do
        print("  lua main.lua " .. task)
        break
    end
end

simple_server()
