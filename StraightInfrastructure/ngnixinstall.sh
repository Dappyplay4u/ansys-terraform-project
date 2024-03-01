#!/bin/bash

# Clean metadata
sudo apt clean metadata

# Update package lists
sudo apt update

# Install Nginx
sudo apt-get install -y nginx

# Start Nginx
sudo systemctl start nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx
