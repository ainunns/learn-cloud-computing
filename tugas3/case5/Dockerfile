# syntax=docker/dockerfile:1

# Build the application from source

FROM golang:1.19 AS build-stage

WORKDIR /app

COPY app/go.mod app/go.sum ./
RUN go mod download

COPY app/*.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /app/binary ./

# Deploy the application binary into a lean image

FROM debian:bullseye-slim AS build-release-stage

# Install nginx and supervisord
RUN apt-get update && \
    apt-get install -y nginx supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /

# Copy the application binary
COPY --from=build-stage /app/binary /app

# Copy configuration files
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /tmp/supervisord.conf
COPY start.sh /start.sh

# Remove default nginx site if it exists
RUN rm -f /etc/nginx/sites-enabled/default

# Make scripts and binary executable
RUN chmod +x /start.sh && \
    chmod +x /app

# Expose port 80 for nginx
EXPOSE 80

ENTRYPOINT ["/bin/sh","/start.sh"]
