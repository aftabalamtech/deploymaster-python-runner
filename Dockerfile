FROM python:3.11-alpine

# Git, Bash, aur minimal build dependencies install kar rahe hain
RUN apk add --no-cache git bash curl build-base libffi-dev

WORKDIR /app

# entrypoint.sh file ko COPY kar rahe hain
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default Web Server Port
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
