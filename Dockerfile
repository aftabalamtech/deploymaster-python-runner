FROM python:3.11-alpine

# Git, Bash, aur essential build packages install kar rahe hain
RUN apk add --no-cache git bash curl build-base libffi-dev

WORKDIR /app

# Entrypoint script copy karke execute permissions de rahe hain
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default Web Port for Render
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
