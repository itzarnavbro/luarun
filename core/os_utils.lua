local os_utils = {}

local IS_WINDOWS = package.config:sub(1,1) == '\\'

os_utils.path = {}
os_utils.path.sep = IS_WINDOWS and '\\' or '/'

function os_utils.path.join(...)
    local parts = {...}
    return table.concat(parts, os_utils.path.sep)
end

function os_utils.os_name()
    if IS_WINDOWS then
        return 'windows'
    elseif os.getenv('HOME') then
        local uname = io.popen('uname -s 2>/dev/null'):read('*a'):lower()
        if uname:match('darwin') then
            return 'mac'
        else
            return 'linux'
        end
    else
        return 'linux'
    end
end

function os_utils.run(cmd)
    local handle = io.popen(cmd .. ' 2>&1')
    if not handle then
        error('Failed to execute command: ' .. cmd)
    end
    local output = handle:read('*a')
    local ok = handle:close()
    if output and output ~= '' then
        io.write(output)
    end
    if not ok then
        error('Command failed: ' .. cmd)
    end
end

function os_utils.mkdir(path)
    if IS_WINDOWS then
        os_utils.run('mkdir "' .. path .. '"')
    else
        os_utils.run('mkdir -p "' .. path .. '"')
    end
end

function os_utils.delete(...)
    local items = {...}
    for _, item in ipairs(items) do
        if IS_WINDOWS then
            local cmd = 'del /q "' .. item .. '" 2>nul || rmdir /s /q "' .. item .. '" 2>nul'
            os.execute(cmd)
        else
            os.execute('rm -f "' .. item .. '" 2>/dev/null || rm -rf "' .. item .. '" 2>/dev/null')
        end
    end
end

return os_utils
