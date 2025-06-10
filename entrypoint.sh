#!/usr/bin/env sh
set -e

# 0. Render Git-Auto-Deploy config
envsubst < /git-auto-deploy.conf.template > git-auto-deploy.conf

# 1. Checkout or update the repo entirely inside the container
if [ ! -d "$DEPLOY_PATH/.git" ]; then
  git clone --depth 1 --branch "$REPO_BRANCH" "$REPO_URL" "$DEPLOY_PATH"
else
  git -C "$DEPLOY_PATH" pull
fi

# 2. Start BrowserSync (serves + live-reloads)
browser-sync start --server "$DEPLOY_PATH" \
                   --files "$DEPLOY_PATH" \
                   --no-open --port "$BS_PORT" &

# 3. Run Git-Auto-Deploy (webhook listener)
exec git-auto-deploy --config-file=/git-auto-deploy.conf
