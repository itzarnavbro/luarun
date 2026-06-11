-- runner.lua - Task registry and execution engine

local runner = {}

-- Store registered tasks
local tasks = {}

-- Register a task with name and function
-- This is exposed as global 'task()' in the tasks.lua environment
function runner.task(name, fn)
    if type(name) ~= 'string' then
        error('Task name must be a string, got ' .. type(name))
    end
    if type(fn) ~= 'function' then
        error('Task function must be a function, got ' .. type(fn))
    end
    tasks[name] = fn
end

-- Run a task by name
-- Returns (nil, error_msg) if task not found, or (result) if task executes
function runner.run(name)
    if not tasks[name] then
        return nil, 'Task not found'
    end
    io.write('[luarun] Running task: ' .. name .. '\n')
    local ok, err = pcall(tasks[name])
    if not ok then
        error('Task error: ' .. tostring(err))
    end
    io.write('[luarun] Done.\n')
    return true
end

-- List all registered tasks
-- Returns table of task names
function runner.list()
    local names = {}
    for name, _ in pairs(tasks) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

-- Export the task function to be used globally
runner.task_global = function(name, fn)
    return runner.task(name, fn)
end

return runner
