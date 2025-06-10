FROM r3v3r/git-auto-deploy:latest

# Add Node & BrowserSync
RUN apk add --no-cache nodejs npm gettext \
 && npm i -g browser-sync

# Git-Auto-Deploy config template + startup script
COPY git-auto-deploy.conf.template /git-auto-deploy.conf.template
COPY entrypoint.sh      /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Defaults (override in docker-compose.yml)
ENV REPO_URL=https://github.com/xjeremy/docker_git-auto-deploy.git \
    REPO_BRANCH=main \
    DEPLOY_PATH=/site \
    BS_PORT=3000 \
    GAD_PORT=8000

EXPOSE 3000 8000
ENTRYPOINT ["/entrypoint.sh"]
