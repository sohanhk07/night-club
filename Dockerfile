# Build stage
FROM alpine as builder

# Install necessary packages
RUN apk update && \
    apk add --no-cache git apache2 && \
    rm -rf /var/cache/apk/*

# Clone the git repository into the Apache web directory
RUN git clone https://github.com/sohanhk07/night-club.git /var/www/html/night-club

# Runtime stage
FROM httpd:alpine

# Copy the Apache web directory from the builder stage
COPY --from=builder /var/www/html /usr/local/apache2/htdocs/

# Expose port 80 to allow outside access to the web server
EXPOSE 80

# Set working directory to Apache's default web directory
WORKDIR /usr/local/apache2/htdocs

# Set metadata for the image
LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="Apache server serving content from a Git repository"

# Start Apache server in the foreground when container starts
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]
