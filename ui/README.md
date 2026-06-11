# luarun Web Dashboard

A beautiful web-based interface for running luarun tasks.

## Quick Start

```bash
lua server.lua
```

Then open your browser to: **http://localhost:8080**

## Features

- 🎨 Beautiful, responsive UI
- ⚡ Real-time task execution
- 📊 Live output streaming
- 🎯 Click-to-run interface
- 📱 Mobile-friendly design

## Customization

### Change Port

```bash
lua server.lua localhost 9000
```

### Change Host

```bash
lua server.lua 0.0.0.0 8080
```

## How It Works

The dashboard communicates with the backend via JSON API:

- `GET /api/tasks` - List all available tasks
- `POST /api/run` - Execute a task (request body: `{"task": "taskname"}`)

## Requirements

Lua with the `socket` library. Most Lua installations include it.

## Architecture

```
server.lua          → HTTP server, routes requests
core/web.lua        → HTTP utilities, JSON encoding/decoding
ui/index.html       → Frontend dashboard
core/runner.lua     → Task execution
tasks.lua           → Your task definitions
```
