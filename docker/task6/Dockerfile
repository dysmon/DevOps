FROM python:3.9-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*
RUN git clone https://gitlab.com/lecture-tasks/intro-devops/aiohttp-simple-server.git /app

FROM python:3.9-alpine

WORKDIR /app

RUN pip install --no-cache-dir aiohttp
COPY --from=builder /app /app
EXPOSE 8080
ENTRYPOINT ["python", "app/main.py"]

