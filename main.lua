#!/usr/bin/env luajit

local runner = require('core.runner')
local parser = require('core.parser')

local task_name = arg[1]

local ok, err = pcall(function()
    parser.load_tasks(runner)
end)

if not ok then
    io.stderr:write(tostring(err) .. '\n')
    os.exit(1)
end

if not task_name then
    local tasks = runner.list()
    if #tasks == 0 then
        io.write('No tasks available.\n')
    else
        io.write('Available tasks:\n')
        for _, name in ipairs(tasks) do
            io.write('  ' .. name .. '\n')
        end
    end
    os.exit(0)
end

local task_result, err = runner.run(task_name)

if err == 'Task not found' then
    io.stderr:write('Error: task \'' .. task_name .. '\' not found.\n')
    local tasks = runner.list()
    if #tasks > 0 then
        io.stderr:write('\nAvailable tasks:\n')
        for _, name in ipairs(tasks) do
            io.stderr:write('  ' .. name .. '\n')
        end
    end
    os.exit(1)
end

local ok, exec_err = pcall(function()
    if not task_result then
        error(tostring(err))
    end
end)

if not ok then
    io.stderr:write(tostring(exec_err) .. '\n')
    os.exit(1)
end
local runner = require('core.runner')
local parser = require('core.parser')

-- Get task name from first CLI argument
local task_name = arg[1]

-- Load tasks from tasks.lua
local ok, err = pcall(function()
    parser.load_tasks(runner)
end)

if not ok then
    io.stderr:write(tostring(err) .. '\n')
    os.exit(1)
end

-- If no task name provided, list available tasks
if not task_name then
    local tasks = runner.list()
    if #tasks == 0 then
        io.write('No tasks available.\n')
    else
        io.write('Available tasks:\n')
        for _, name in ipairs(tasks) do
            io.write('  ' .. name .. '\n')
        end
    end
    os.exit(0)
end

-- Run the requested task
local task_result, err = runner.run(task_name)

if err == 'Task not found' then
    io.stderr:write('Error: task \'' .. task_name .. '\' not found.\n')
    -- List available tasks for context
    local tasks = runner.list()
    if #tasks > 0 then
        io.stderr:write('\nAvailable tasks:\n')
        for _, name in ipairs(tasks) do
            io.stderr:write('  ' .. name .. '\n')
        end
    end
    os.exit(1)
end

-- Check for errors during task execution
local ok, exec_err = pcall(function()
    if not task_result then
        error(tostring(err))
    end
end)

if not ok then
    io.stderr:write(tostring(exec_err) .. '\n')
    os.exit(1)
end
