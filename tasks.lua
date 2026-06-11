-- tasks.lua - Define your tasks here
-- Each task is registered with task(name, function)
-- Use run(cmd) to execute shell commands

local os_utils = require('core.os_utils')

-- Hello world example task
task('hello', function()
    print('Hello from luarun!')
end)

-- Build task - compiles a simple C program (if gcc available)
task('build', function()
    local os_name = os_utils.os_name()
    print('[task] Building on ' .. os_name)
    
    -- Try to detect if we have a compiler
    if os_name == 'windows' then
        -- Try to compile a simple C file if it exists
        print('[task] Looking for C sources to compile...')
    else
        -- On Unix, try to compile
        print('[task] Looking for C sources to compile...')
    end
    
    print('[task] Build task complete.')
end)

-- Clean task - removes build artifacts
task('clean', function()
    print('[task] Cleaning build artifacts...')
    local os_utils = require('core.os_utils')
    -- Example: delete build artifacts
    -- os_utils.delete('*.o', 'build/')
    print('[task] Clean complete.')
end)

-- Test task - run tests
task('test', function()
    print('[task] Running tests...')
    print('[task] All tests passed!')
end)

-- Directory operations example
task('make-dir', function()
    print('[task] Creating test directory...')
    local os_utils = require('core.os_utils')
    local test_dir = os_utils.path.join('test_build', 'subdir')
    os_utils.mkdir(test_dir)
    print('[task] Directory created at: ' .. test_dir)
end)

-- Path joining example
task('show-paths', function()
    print('[task] OS name: ' .. os_utils.os_name())
    print('[task] Path separator: ' .. os_utils.path.sep)
    local joined = os_utils.path.join('path', 'to', 'file')
    print('[task] Joined path: ' .. joined)
end)
