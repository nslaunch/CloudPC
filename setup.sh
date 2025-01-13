#!/bin/bash

# Script to Install and Customize Desktop Environments in GitHub Codespaces
# This code is the intellectual property of @ECL_Adler400 and is protected under applicable copyright and intellectual property laws.
# Unauthorized access, use, modification, reproduction, or distribution of this code, in part or in whole, is strictly prohibited.

set -e
set -o pipefail

# Function to display a menu for the user to choose DE(s)
choose_desktop_environment() {
    echo "Please choose Desktop Environment(s) to install (separate multiple choices with spaces):"
    echo "1. XFCE (Default)"
    echo "2. GNOME"
    echo "3. KDE Plasma"
    echo "4. LXQt"
    read -p "Enter your choice(s) [Default: XFCE]: " choices

    # Default to XFCE if input is invalid or empty
    if [[ -z "$choices" ]]; then
        choices="1"
    fi

    for choice in $choices; do
        case $choice in
            1) echo "Installing XFCE..."; sudo apt install -y xfce4 xfce4-goodies; install_theme_xfce ;;
            2) echo "Installing GNOME..."; sudo apt install -y ubuntu-gnome-desktop; install_theme_gnome ;;
            3) echo "Installing KDE Plasma..."; sudo apt install -y kde-plasma-desktop; install_theme_kde ;;
            4) echo "Installing LXQt..."; sudo apt install -y lxqt; install_theme_lxqt ;;
            *) echo "Invalid choice: $choice. Skipping..." ;;
        esac
    done
}

# Function to customize XFCE
install_theme_xfce() {
    echo "Customizing XFCE..."
    sudo apt install -y arc-theme papirus-icon-theme
    xfconf-query -c xsettings -p /Net/ThemeName -s "Arc-Dark"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus"
}

# Function to customize GNOME
install_theme_gnome() {
    echo "Customizing GNOME..."
    sudo apt install -y gnome-tweaks arc-theme papirus-icon-theme
    gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
    gsettings set org.gnome.desktop.interface icon-theme "Papirus"
}

# Function to customize KDE Plasma
install_theme_kde() {
    echo "Customizing KDE Plasma..."
    sudo apt install -y plasma-look-and-feel-org-cinnamon.desktop arc-kde papirus-icon-theme
    lookandfeeltool -a org.cinnamon.desktop
}

# Function to customize LXQt
install_theme_lxqt() {
    echo "Customizing LXQt..."
    sudo apt install -y arc-theme papirus-icon-theme
    pcmanfm-qt --set-wallpaper="/usr/share/backgrounds/xfce/default-wallpaper.png"
}

# 
# Start script
clear
echo "🚀 Updating package list..."
sudo apt update

# Install basic packages
sudo apt install -y tightvncserver python3-websockify novnc neofetch firefox

# Prompt user to update to the latest Ubuntu LTS
update_to_latest_lts

# Prompt user to choose desktop environments
choose_desktop_environment

# Generate SSL certificate for noVNC
echo "🔒 Generating SSL certificate for noVNC..."
openssl req -x509 -nodes -newkey rsa:3072 -keyout ~/novnc.pem -out ~/novnc.pem -days 3650 -subj "/CN=localhost"

# Configure VNC Server
echo "🖥️ Starting VNC Server (as root)..."
USER=root vncserver || tru

# Kill existing VNC sessions
vncserver -kill :1 || true

# Configure xstartup file
cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
xrdb \$HOME/.Xresources
if [ -x /usr/bin/startxfce4 ]; then
    startxfce4 &
elif [ -x /usr/bin/gnome-session ]; then
    gnome-session &
elif [ -x /usr/bin/startplasma-x11 ]; then
    startplasma-x11 &
elif [ -x /usr/bin/startlxqt ]; then
    startlxqt &
else
    echo "No recognized desktop environment found in xstartup."
    exit 1
fi
EOF

chmod +x ~/.vnc/xstartup

# Final instructions
echo "✅ Setup complete! You can start the VNC server with:"
echo "   vncserver :1"
echo "📡 For browser access, start noVNC with:"
echo "   websockify -D --web=/usr/share/novnc/ --cert=\$HOME/novnc.pem 6081 localhost:5901"
