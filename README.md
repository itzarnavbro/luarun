# luarun · Cross-Platform LuaJIT Script Runner

A lightweight task runner written in LuaJIT. Like a mini Makefile, but in Lua.

## What is luarun?

`luarun` is a simple task runner that lets you define tasks in Lua and execute them from the command line. No external dependencies, no LuaRocks—just pure Lua.

## Installation

### macOS

```bash
# Using Homebrew
brew install luajit

# Or from source
curl -O http://luajit.org/download/LuaJIT-2.1.0-beta3.tar.gz
tar xzf LuaJIT-2.1.0-beta3.tar.gz
cd LuaJIT-2.1.0-beta3
make && sudo make install
```

### Linux (Ubuntu/Debian)

```bash
sudo apt-get install luajit
```

### Linux (Fedora/RHEL)

```bash
sudo dnf install luajit
```

### Windows

Download the LuaJIT binaries from [luajit.org](http://luajit.org/):
- Extract to a directory (e.g., `C:\luajit`)
- Add the directory to your `PATH` environment variable
- Or run `luajit.exe` directly with full path

## Quick Start

### 1. Define Tasks

Edit `tasks.lua` to define your tasks:

```lua
task('hello', function()
    print('Hello, World!')
end)

task('build', function()
    run('echo Building...')
    run('gcc -o myapp main.c')
end)

task('clean', function()
    os_utils.delete('myapp', '*.o')
end)
```

### 2. Run a Task

```bash
lua main.lua hello
# Output:
# [luarun] Running task: hello
# Hello, World!
# [luarun] Done.
```

### 3. Web Dashboard (Beautiful UI!)

For an gorgeous web interface:

```bash
lua server.lua
# Opens at http://localhost:8080
```

The dashboard features:
- 🎨 Beautiful gradient UI
- ⚡ One-click task execution
- 📊 Live output viewing
- 📱 Fully responsive design

**Note:** The web server requires Lua's `socket` library. If not available, use the CLI.

### 4. List All Tasks

```bash
lua main.lua
# Output:
# Available tasks:
#   build
#   clean
#   hello
```

## Available Functions in tasks.lua

### `task(name, fn)`

Register a task with a given name and function.

```lua
task('mytask', function()
    print('Doing work...')
end)
```

### `run(cmd)`

Execute a shell command. Output is captured and printed. Raises an error if the command fails.

```lua
run('echo Hello')
run('gcc -o myapp main.c')
```

### `os_utils.run(cmd)`

Same as `run()`, but called explicitly via the `os_utils` module.

### `os_utils.mkdir(path)`

Create a directory including parent directories (cross-platform equivalent of `mkdir -p`).

```lua
os_utils.mkdir('build/output/debug')
```

### `os_utils.delete(...)`

Delete files or directories (cross-platform equivalent of `rm -f` on Unix, `del` on Windows).

```lua
os_utils.delete('*.o', 'build/', 'temp.txt')
```

### `os_utils.path.join(...)`

Join path segments with the correct separator for the current OS.

```lua
local file = os_utils.path.join('src', 'main', 'lib.lua')
-- On Windows: 'src\main\lib.lua'
-- On Unix: 'src/main/lib.lua'
```

### `os_utils.os_name()`

Return the OS name: `'windows'`, `'mac'`, or `'linux'`.

```lua
local os_name = os_utils.os_name()
if os_name == 'windows' then
    print('Running on Windows')
end
```

## Cross-Platform Tips

**Use `os_utils.path.join()` instead of hardcoding path separators:**

```lua
-- BAD ❌
local file = 'src/main.lua'
local file = 'src\\main.lua'

-- GOOD ✅
local file = os_utils.path.join('src', 'main.lua')
```

**Use `os_utils.mkdir()` for directory creation:**

```lua
-- BAD ❌
run('mkdir mydir')  -- fails on Windows

-- GOOD ✅
os_utils.mkdir('mydir')
```

**Detect the OS and run platform-specific commands:**

```lua
task('build', function()
    if os_utils.os_name() == 'windows' then
        run('cl.exe main.c')  -- MSVC compiler
    else
        run('gcc main.c')     -- GCC on Unix
    end
end)
```

## Project Structure

```
luarun/
├── main.lua              -- Entry point
├── server.lua            -- Web dashboard server
├── core/
│   ├── runner.lua        -- Task registry and execution
│   ├── os_utils.lua      -- Cross-platform OS utilities
│   ├── parser.lua        -- Loads tasks.lua safely
│   └── web.lua           -- HTTP utilities
├── ui/
│   ├── index.html        -- Beautiful web dashboard
│   ├── server-simple.lua -- Task list viewer
│   └── README.md         -- UI documentation
├── tasks.lua             -- Your task definitions
└── README.md             -- Main documentation
```

## Examples

### A Real-World tasks.lua

```lua
-- Build a C project
task('build', function()
    os_utils.mkdir('build')
    run('gcc -o build/myapp src/main.c src/utils.c')
    print('✓ Build complete')
end)

-- Clean build artifacts
task('clean', function()
    os_utils.delete('build/')
    print('✓ Clean complete')
end)

-- Run tests
task('test', function()
    run('build/myapp --test')
end)

-- Install (copy to system location)
task('install', function()
    local target = os_utils.path.join(os.getenv('HOME'), '.local', 'bin', 'myapp')
    os_utils.mkdir(os.getenv('HOME'), '.local', 'bin')
    run('cp build/myapp ' .. target)
    print('✓ Installed to ' .. target)
end)
```

## Error Handling

If a task fails, `luarun` prints the error and lists available tasks:

```bash
$ lua main.lua nonexistent
Error: task 'nonexistent' not found.

Available tasks:
  build
  clean
  hello
```

If a command within a task fails, the task stops with an error:

```bash
$ lua main.lua build
[luarun] Running task: build
gcc: command not found
Command failed: gcc -o myapp main.c
```

## Web Dashboard

luarun includes a beautiful web-based dashboard for running tasks visually.

### Starting the Dashboard

```bash
lua server.lua [host] [port]
```

Examples:
```bash
lua server.lua                    # localhost:8080
lua server.lua 0.0.0.0 9000       # 0.0.0.0:9000
```

Then open your browser to the displayed URL.

### Dashboard Features

- **Task Grid** - Click any task card to run it
- **Live Output** - See command output in real-time
- **Status Indicators** - Visual feedback (running, success, error)
- **Responsive Design** - Works on mobile, tablet, desktop
- **Beautiful UI** - Purple gradient theme with smooth animations

### API Endpoints

The dashboard communicates with these REST endpoints:

- `GET /` - Serve the dashboard HTML
- `GET /api/tasks` - List all available tasks (JSON)
- `POST /api/run` - Execute a task

Example:
```bash
curl http://localhost:8080/api/tasks
# Response: {"tasks":["hello","build","clean"]}

curl -X POST http://localhost:8080/api/run \
  -H "Content-Type: application/json" \
  -d '{"task":"hello"}'
```

## Deployment

### GitHub Pages (FREE ✅ - Best Option)

The web dashboard UI is automatically deployed to GitHub Pages on every push to `main`.

**Access:** `https://itzarnavbro.github.io/luarun/`

- ✅ **Free forever**
- ✅ Automatic on every push
- ✅ No backend needed (static HTML)
- ✅ Fast CDN
- ⚠️ Dashboard is UI-only (requires separate backend for task execution)

See [DEPLOY.md](DEPLOY.md) for detailed instructions.

## CI/CD Pipeline

GitHub Actions automatically:
- ✅ Validates Lua syntax
- ✅ Checks project structure
- ✅ Deploys to GitHub Pages
- ✅ Builds Docker images (to GitHub Container Registry)

**Check status:** https://github.com/YOUR_USERNAME/luarun/actions

**Free limits:**
- 2,000 GitHub Actions minutes/month (free tier)
- GitHub Container Registry: 500MB free storage

## License

MIT

## Contributing

Feel free to extend `luarun` with more features. Keep it simple, keep it Lua.
