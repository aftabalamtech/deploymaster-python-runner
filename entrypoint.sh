#!/bin/bash
set -e

# Unbuffer outputs so logs print in exact order
export PYTHONUNBUFFERED=1

echo "=== 🚀 DeployMaster Python Runner Starting ==="

# 1. Validation: Env variable check
if [ -z "$GIT_REPO_URL" ]; then
    echo "❌ ERROR: GIT_REPO_URL environment variable is missing!"
    exit 1
fi

# Clean Repo URL
CLEAN_URL=$(echo "$GIT_REPO_URL" | sed -e 's|https://||' -e 's|http://||')

# Private vs Public URL construct
if [ -n "$GITHUB_PAT" ]; then
    echo "🔑 Using GitHub PAT token for Private Repo access..."
    TARGET_REPO="https://${GITHUB_PAT}@${CLEAN_URL}"
else
    echo "🌐 No GITHUB_PAT provided, assuming Public Repo..."
    TARGET_REPO="https://${CLEAN_URL}"
fi

# Branch selection
BRANCH_NAME="${GIT_BRANCH:-main}"

echo "📥 Cloning repository ($BRANCH_NAME)..."
rm -rf /app/src
git clone --depth 1 --branch "$BRANCH_NAME" "$TARGET_REPO" /app/src

# Navigate to cloned source directory and set PYTHONPATH
cd /app/src
export PYTHONPATH="/app/src:$PYTHONPATH"

echo "📂 Repository Contents:"
ls -la /app/src

# 2. Dependencies installation
if [ -f "requirements.txt" ]; then
    echo "📦 Installing requirements.txt dependencies..."
    pip install --no-cache-dir -r requirements.txt
elif [ -f "Pipfile" ]; then
    echo "📦 Pipfile detected, installing pipenv & dependencies..."
    pip install --no-cache-dir pipenv
    pipenv install --system
elif [ -f "pyproject.toml" ]; then
    echo "📦 pyproject.toml detected, installing poetry & dependencies..."
    pip install --no-cache-dir poetry
    poetry config virtualenvs.create false
    poetry install --no-root
fi

# 3. Dynamic Port Setup
PORT_TO_USE="${PORT:-8080}"
export PORT=$PORT_TO_USE

# 4. App Execution
echo "=== 🔥 Launching User Application ==="

# Fallback auto-detection if START_COMMAND is default or gunicorn app:app
if [ -n "$START_COMMAND" ]; then
    echo "▶️ Executing Custom Command: $START_COMMAND"
    exec bash -c "$START_COMMAND"
elif [ -f "app.py" ]; then
    echo "▶️ Found app.py, running with Python..."
    exec python app.py
elif [ -f "main.py" ]; then
    echo "▶️ Found main.py, running with Python..."
    exec python main.py
else
    echo "❌ ERROR: No start file (app.py / main.py) or START_COMMAND found!"
    exit 1
fi
