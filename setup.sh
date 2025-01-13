#!/bin/bash

# Script to Install a Desktop Environment in GitHub Codespaces
# This script allows the user to choose from multiple desktop environments and sets up noVNC for remote access.

set -e
set -o pipefail

# Function to display a menu and let the user choose a DE
choose_desktop_environment() {
    echo "Please choose a Desktop Environment to install:"
    echo "1. GNOME"
    echo "2. KDE Plasma"
    echo "3. XFCE"
    echo "4. Cinnamon"
    echo "5. MATE"
    echo "6. LXQt"
    echo "7. Budgie"
    echo "8. Deepin"
    echo "9. Pantheon"
    echo "10. Exit"

    read -p "Enter the number of your choice: " choice

    case $choice in
        1) echo "Installing GNOME..."; sudo apt install -y ubuntu-gnome-desktop ;;
        2) echo "Installing KDE Plasma..."; sudo apt install -y kde-plasma-desktop ;;
        3) echo "Installing XFCE..."; sudo apt install -y xfce4 xfce4-goodies ;;
        4) echo "Installing Cinnamon..."; sudo apt install -y cinnamon ;;
        5) echo "Installing MATE..."; sudo apt install -y mate-desktop-environment ;;
        6) echo "Installing LXQt..."; sudo apt install -y lxqt ;;
        7) echo "Installing Budgie..."; sudo apt install -y budgie-desktop ;;
        8) echo "Installing Deepin..."; sudo apt install -y deepin-desktop-environment ;;
        9) echo "Installing Pantheon..."; sudo apt install -y pantheon ;;
        10) echo "Exiting script. No changes were made."; exit 0 ;;
        *) echo "Invalid choice. Please run the script again."; exit 1 ;;
    esac
}

echo "🚀 Updating package list..."
sudo apt update
sudo apt install -y tightvncserver


# Prompt user to choose a desktop environment
choose_desktop_environment

echo "🔒 Generating SSL certificate for noVNC..."
openssl req -x509 -nodes -newkey rsa:3072 -keyout ~/novnc.pem -out ~/novnc.pem -days 3650 -subj "/CN=localhost"

echo "🖥️ Starting VNC Server (as root)..."
USER=root vncserver || true

echo "🛑 Killing any existing VNC sessions..."
vncserver -kill :1 || true

echo "📁 Backing up and creating a new xstartup file..."
if [ -f ~/.vnc/xstartup ]; then
    mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
    echo "🔙 Old xstartup file backed up as ~/.vnc/xstartup.bak"
fi

# Create a new xstartup file based on the installed desktop environment
cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
xrdb \$HOME/.Xresources
# Automatically start the desktop environment
if [ -x /usr/bin/startplasma-x11 ]; then
    startplasma-x11 &
elif [ -x /usr/bin/startxfce4 ]; then
    startxfce4 &
elif [ -x /usr/bin/cinnamon-session ]; then
    cinnamon-session &
elif [ -x /usr/bin/mate-session ]; then
    mate-session &
elif [ -x /usr/bin/budgie-desktop ]; then
    budgie-desktop &
elif [ -x /usr/bin/startlxqt ]; then
    startlxqt &
elif [ -x /usr/bin/startdde ]; then
    startdde &
elif [ -x /usr/bin/gnome-session ]; then
    gnome-session &
elif [ -x /usr/bin/pantheon-session ]; then
    pantheon-session &
else
    echo "No recognized desktop environment found in xstartup."
    exit 1
fi
EOF

chmod +x ~/.vnc/xstartup

echo "✅ Setup complete! You can start the VNC server with:"
echo "   vncserver :1"
echo "📡 For browser access, start noVNC with:"
echo "   websockify -D --web=/usr/share/novnc/ --cert=\$HOME/novnc.pem 6081 localhost:5901"

echo "💡 Tip: Replace '6081' with a unique port number if needed."
