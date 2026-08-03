# DeployMaster Python Runner (Modular Wrapper)

An ultra-lightweight, high-performance Python application runner for DeployMaster SaaS platform.

## Required Environment Variables (Passed by DeployMaster Backend):

| Variable | Required | Description | Example |
|---|---|---|---|
| `GIT_REPO_URL` | **Yes** | Repository URL | `github.com/user/private-repo` |
| `GITHUB_PAT` | Optional | GitHub Access Token (for private repos) | `ghp_xxxx` |
| `GIT_BRANCH` | Optional | Target branch (Default: `main`) | `main` |
| `START_COMMAND` | Optional | Custom execution command | `gunicorn app:app` |
| `PORT` | Optional | Listening Port (Default: `8080`) | `8080` |
