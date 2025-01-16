#!/bin/bash

# Script to Install and Configure XFCE Desktop Environment in GitHub Codespaces
# This code is the intellectual property of @ECL_Adler400 and is protected under applicable copyright and intellectual property laws.
# Unauthorized access, use, modification, reproduction, or distribution of this code, in part or in whole, is strictly prohibited.

set -e
set -o pipefail

# Start script
clear
echo "🚀 Updating package list and installing necessary packages..."
sudo apt update

# Install XFCE and necessary utilities
echo "📦 Installing XFCE and basic utilities..."
sudo apt install -y xfce4 xfce4-goodies tightvncserver python3-websockify novnc neofetch firefox dbus-x11 x11-xserver-utils xinit

# Configure VNC Server
echo "🔧 Configuring VNC Server..."
USER=root vncserver || true
vncserver -kill :1 || true

cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
xrdb \$HOME/.Xresources
startxfce4 &
EOF

chmod +x ~/.vnc/xstartup

# Generate SSL certificate for noVNC
echo "🔒 Generating SSL certificate for noVNC..."
openssl req -x509 -nodes -newkey rsa:3072 -keyout ~/novnc.pem -out ~/novnc.pem -days 3650 -subj "/CN=localhost"

# Final instructions for VNC and noVNC
echo "✅ Setup complete! To start the XFCE desktop environment:"
echo "1. Start the VNC server:"
echo "   vncserver :1"
echo "2. Start noVNC for browser access:"
echo "   websockify -D --web=/usr/share/novnc/ --cert=\$HOME/novnc.pem 6081 localhost:5901"
echo "💡 Tip: Replace '6081' with a unique port number if needed."
