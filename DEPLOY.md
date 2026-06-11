# Deployment Guide

This guide covers deploying luarun to various platforms.

## Free Options

### GitHub Pages (FREE ✅ - Recommended)

The UI is automatically deployed to GitHub Pages on every push to `main`.

**Access:** `https://YOUR_USERNAME.github.io/luarun`

**Pros:**
- ✅ Free forever
- ✅ Automatic deployment
- ✅ Fast CDN
- ✅ No credit card required

**Cons:**
- Static HTML only (no backend execution)
- Dashboard UI only (for demo/reference)

### Docker Locally (FREE ✅)

Build and run Docker image on your machine:

```bash
docker build -t luarun .
docker run -p 8080:8080 luarun
```

Then visit: http://localhost:8080 (full functionality)

**Pros:**
- ✅ Free
- ✅ Full functionality
- ✅ Complete control

**Cons:**
- Runs on your local machine
- Requires Docker installed

### GitHub Container Registry (FREE ✅ - Limited)

Images are automatically built and pushed to GitHub Container Registry on every push to `main`.

```bash
docker pull ghcr.io/YOUR_USERNAME/luarun:main
docker run -p 8080:8080 ghcr.io/YOUR_USERNAME/luarun:main
```

**Free limits:**
- 500MB storage
- Unlimited bandwidth
- Requires personal GitHub account

## Paid/Freemium Options

### Railway.app (Freemium)

1. Sign up at https://railway.app
2. Connect your GitHub repo
3. Add environment variable: `PORT=8080`
4. Start command: `lua server.lua 0.0.0.0 8080`
5. Deploy!

**Pros:**
- Good free tier ($5/month credits)
- Easy GitHub integration
- Great for small projects

**Cons:**
- Free tier limited
- After credits expire, paid

### Replit (Freemium)

1. Import from GitHub at https://replit.com/github/YOUR_USERNAME/luarun
2. Run: `lua server.lua 0.0.0.0 3000`
3. Access via Replit's built-in web preview

**Pros:**
- Free tier available
- Very easy setup
- Built-in IDE

**Cons:**
- Projects sleep if inactive
- Free tier limited resources
- Slower than paid options

### DigitalOcean (Paid - $5+/month)

1. Connect GitHub repo at https://cloud.digitalocean.com/apps
2. Set up Docker or direct deploy
3. Configure port: 8080
4. Deploy!

**Pros:**
- Reliable infrastructure
- Good pricing

**Cons:**
- Minimum $5/month
- No free tier

## Quick Summary: Which Option to Choose?

| Need | Best Choice | Cost |
|------|-------------|------|
| Demo/Portfolio | GitHub Pages | FREE |
| Full local testing | Docker locally | FREE |
| Cloud but free | Railway (limited) | FREE ($5 credits) |
| Production | DigitalOcean/Railway | $5+/month |

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

### Railway/Replit/DigitalOcean
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
