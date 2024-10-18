#!/bin/bash

# Function to print colored text
print_message() {
    echo -e "\e[1;32m$1\e[0m"
}

# Update and upgrade the system
print_message "Updating and upgrading the system..."
sudo pacman -Syu --noconfirm

# Install yay (AUR helper)
print_message "Installing yay (AUR helper)..."
sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..

# Install Docker and other server-related packages
print_message "Installing Docker, Docker Compose, OpenVPN, Tailscale, and other server packages..."
sudo pacman -S --noconfirm docker docker-compose openvpn openvpn-server tailscale

# Start and enable Docker
print_message "Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Install a minimal GUI (i3 and lightdm)
print_message "Installing i3 window manager and LightDM..."
sudo pacman -S --noconfirm i3 lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xorg xorg-server xorg-xinit xterm
sudo systemctl enable lightdm

# Install code-server (VSCode in the browser) from AUR
print_message "Installing code-server from AUR..."
yay -S code-server --noconfirm

# Configure code-server with a password
print_message "Configuring code-server..."
mkdir -p ~/.config/code-server
echo "bind-addr: 127.0.0.1:8080" > ~/.config/code-server/config.yaml
echo "auth: password" >> ~/.config/code-server/config.yaml
echo "password: keqing@123" >> ~/.config/code-server/config.yaml
echo "cert: false" >> ~/.config/code-server/config.yaml

# Enable and start code-server
print_message "Enabling and starting code-server..."
sudo systemctl enable --now code-server@$USER

# Configure OpenVPN
print_message "Configuring OpenVPN..."
sudo systemctl enable openvpn-server@server
sudo systemctl start openvpn-server@server

# Pull docker images (Ubuntu, MySQL, Redis)
print_message "Pulling Docker images (Ubuntu, MySQL, Redis)..."
sudo docker pull ubuntu
sudo docker pull mysql
sudo docker pull redis

# Create external Docker network for LAN interaction
print_message "Creating an external Docker network for LAN interaction..."
LAN_INTERFACE=$(ip route | grep default | awk '{print $5}')
sudo docker network create --driver bridge --subnet 192.168.10.0/24 --gateway 192.168.10.1 --opt com.docker.network.bridge.name=br-$LAN_INTERFACE lan_network

# Install additional packages (e.g., networking tools, system monitoring tools)
print_message "Installing additional server-related packages (htop, net-tools, etc.)..."
sudo pacman -S --noconfirm htop net-tools neofetch

# Final system upgrade
print_message "Final system upgrade to ensure all packages are up-to-date..."
sudo pacman -Syu --noconfirm

print_message "Arch Linux server setup completed successfully!"

