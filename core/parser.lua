local parser = {}

function parser.load_tasks(runner)
    local tasks_file = 'tasks.lua'
    
    local f = io.open(tasks_file, 'r')
    if not f then
        error('Error: tasks.lua not found in current directory.')
    end
    f:close()
    
    local env = {
        task = function(name, fn)
            return runner.task(name, fn)
        end,
        run = function(cmd)
            local os_utils = require('core.os_utils')
            os_utils.run(cmd)
        end,
        require = require,
        print = print,
        table = table,
        string = string,
        io = io,
        os = os,
        tostring = tostring,
        tonumber = tonumber,
        type = type,
        pairs = pairs,
        ipairs = ipairs,
        next = next,
        setmetatable = setmetatable,
        getmetatable = getmetatable,
        rawget = rawget,
        rawset = rawset,
        error = error,
        _G = _G,
    }
    
    local tasks_code, err = loadfile(tasks_file)
    if not tasks_code then
        error('Error loading tasks.lua: ' .. tostring(err))
    end
    
    if setfenv then
        setfenv(tasks_code, env)
    else
        local success, result = pcall(function()
            return load(string.dump(tasks_code), tasks_file, 't', env)
        end)
        if success then
            tasks_code = result
        end
    end
    
    local ok, err = pcall(tasks_code)
    if not ok then
        error('Error executing tasks.lua: ' .. tostring(err))
    end
end

return parser
