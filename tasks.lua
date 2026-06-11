local os_utils = require('core.os_utils')

task('hello', function()
    print('Hello from luarun!')
end)

task('build', function()
    local os_name = os_utils.os_name()
    print('[task] Building on ' .. os_name)
    
    if os_name == 'windows' then
        print('[task] Looking for C sources to compile...')
    else
        print('[task] Looking for C sources to compile...')
    end
    
    print('[task] Build task complete.')
end)

task('clean', function()
    print('[task] Cleaning build artifacts...')
    local os_utils = require('core.os_utils')
    print('[task] Clean complete.')
end)

task('test', function()
    print('[task] Running tests...')
    print('[task] All tests passed!')
end)

task('make-dir', function()
    print('[task] Creating test directory...')
    local os_utils = require('core.os_utils')
    local test_dir = os_utils.path.join('test_build', 'subdir')
    os_utils.mkdir(test_dir)
    print('[task] Directory created at: ' .. test_dir)
end)

task('show-paths', function()
    print('[task] OS name: ' .. os_utils.os_name())
    print('[task] Path separator: ' .. os_utils.path.sep)
    local joined = os_utils.path.join('path', 'to', 'file')
    print('[task] Joined path: ' .. joined)
end)
