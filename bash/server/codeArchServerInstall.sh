#!/bin/bash

echo "Updating system and installing developer tools..."

# Update system
sudo pacman -Syu --noconfirm

# Install core development tools
sudo pacman -S --noconfirm base-devel git vim neovim tmux zsh

# Install Docker and enable it
sudo pacman -S --noconfirm docker
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo pacman -S --noconfirm docker-compose

# Install Node.js, npm, and Yarn
sudo pacman -S --noconfirm nodejs npm yarn

# Install Python and pip
sudo pacman -S --noconfirm python python-pip

# Install Java (OpenJDK)
sudo pacman -S --noconfirm jdk-openjdk

# Install Go
sudo pacman -S --noconfirm go

# Install C++ build tools (cmake, g++)
sudo pacman -S --noconfirm cmake gcc

# Install Ruby and Rails
sudo pacman -S --noconfirm ruby
gem install rails

# Optional: Change default shell to Zsh and configure it
chsh -s $(which zsh)

echo "Development environment setup completed!"

