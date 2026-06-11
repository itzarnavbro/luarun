# Deployment Guide

This guide covers deploying luarun to various platforms.

## GitHub Pages (Static Dashboard Only)

The UI is automatically deployed to GitHub Pages on every push to `main`.

**Access:** `https://YOUR_USERNAME.github.io/luarun`

*Note: This hosts only the static HTML dashboard without the backend.*

## Docker Deployment

### Build Image Locally

```bash
docker build -t luarun .
docker run -p 8080:8080 luarun
```

Then visit: http://localhost:8080

### GitHub Container Registry

Images are automatically built and pushed to GitHub Container Registry on every push to `main`.

```bash
docker pull ghcr.io/YOUR_USERNAME/luarun:main
docker run -p 8080:8080 ghcr.io/YOUR_USERNAME/luarun:main
```

## Cloud Deployments

### Heroku

1. Install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli
2. Create app:
   ```bash
   heroku create your-app-name
   ```
3. Add Procfile to repo:
   ```
   web: lua server.lua 0.0.0.0 $PORT
   ```
4. Deploy:
   ```bash
   git push heroku main
   ```
5. Access: `https://your-app-name.herokuapp.com`

### Railway.app

1. Sign up at https://railway.app
2. Connect your GitHub repo
3. Add environment variable: `PORT=8080`
4. Start command: `lua server.lua 0.0.0.0 8080`
5. Deploy!

### Replit

1. Import from GitHub at https://replit.com/github/YOUR_USERNAME/luarun
2. Run: `lua server.lua 0.0.0.0 3000`
3. Access via Replit's built-in web preview

### DigitalOcean App Platform

1. Connect GitHub repo at https://cloud.digitalocean.com/apps
2. Set up Docker or direct deploy
3. Configure port: 8080
4. Deploy!

## GitHub Actions Status

Check your CI/CD status: `https://github.com/YOUR_USERNAME/luarun/actions`

### Workflows

- **CI** (ci.yml) - Runs on every push
  * Lua syntax validation
  * Project structure verification
  * HTML dashboard checks
  * Deploys to GitHub Pages

- **Docker** (docker.yml) - Runs on push to main
  * Builds Docker image
  * Pushes to GitHub Container Registry

## Environment Variables

- `PORT` - Server port (default: 8080)
- `HOST` - Bind address (default: 0.0.0.0)

Example:
```bash
PORT=3000 lua server.lua
```

## Requirements by Platform

### Local Development
- Lua 5.4+
- luasocket (for web server)

### Docker
- Docker Engine

### GitHub Pages
- GitHub account with repo
- Actions enabled

### Heroku/Railway/Replit
- Account on the platform
- Connected GitHub repo

## Troubleshooting

**Port already in use:**
```bash
lua server.lua 0.0.0.0 9000
```

**Tasks not showing in dashboard:**
- Ensure `tasks.lua` is in the root directory
- Check file syntax: `lua -c tasks.lua`

**Docker build fails:**
- Ensure Dockerfile is in repo root
- Check Docker daemon is running

## Performance Tips

- Use CDN caching for static assets
- Deploy on server close to your location
- Use smaller task definitions when possible
- Monitor GitHub Actions minutes (free tier: 2000/month)
