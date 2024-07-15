# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set environment variable to configure tzdata non-interactively
ENV DEBIAN_FRONTEND=noninteractive

# Set up the working directory
WORKDIR /app

# Install necessary packages
RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean

# Copy the requirements file first to leverage Docker cache
COPY app/requirements.txt /app/requirements.txt

# Install Python dependencies
RUN pip install -r /app/requirements.txt

# Copy the rest of the application files
COPY . /app

# Copy the Nginx configuration file to the appropriate location
COPY nginx.conf /etc/nginx/sites-available/default

# Ensure Nginx site is enabled
RUN rm -f /etc/nginx/sites-enabled/default && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Expose port 81 for the web server
EXPOSE 81

# Expose Flask default port
EXPOSE 5000

# Set environment variable for Flask
ENV SECRET_KEY=aeffabef0a8a4d1e9abf4a7b0a2a4d2e

# Define the Docker volume
VOLUME ["/app_data"]

# Start both Flask and Nginx
CMD service nginx start && python /app/run.py
