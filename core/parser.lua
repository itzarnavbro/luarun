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
    }
    
    local tasks_code, err = loadfile(tasks_file, 'bt', env)
    if not tasks_code then
        tasks_code, err = loadfile(tasks_file)
        if not tasks_code then
            error('Error loading tasks.lua: ' .. tostring(err))
        end
        if setfenv then
            setfenv(tasks_code, env)
        end
    end
    
    local ok, err = pcall(tasks_code)
    if not ok then
        error('Error executing tasks.lua: ' .. tostring(err))
    end
end

return parser
