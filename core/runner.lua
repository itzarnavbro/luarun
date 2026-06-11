local runner = {}

local tasks = {}

function runner.task(name, fn)
    if type(name) ~= 'string' then
        error('Task name must be a string, got ' .. type(name))
    end
    if type(fn) ~= 'function' then
        error('Task function must be a function, got ' .. type(fn))
    end
    tasks[name] = fn
end

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

function runner.list()
    local names = {}
    for name, _ in pairs(tasks) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

runner.task_global = function(name, fn)
    return runner.task(name, fn)
end

return runner
