![Banner Image](./images/banner.png)

# GitHub Desktop Environment Setup

This repository provides an interactive **setup script** to install and run a desktop environment (DE) inside **GitHub Codespaces**. It includes support for multiple DEs, letting users choose their preferred option during the installation process.



## 🚀 Features

- **Customizable Setup**: Choose from popular desktop environments like GNOME, KDE Plasma, XFCE, Cinnamon, MATE, and more.
- **Web-Based Access**: Access your Codespace desktop using **VNC** and **noVNC** in your browser.
- **Secure Access**: Automatically generates SSL certificates for encrypted noVNC connections.



## 📋 Requirements

- **GitHub Codespaces** with sufficient resources (at least 2 cores and 4 GB RAM recommended).
- **Internet connection** to install packages and access the desktop remotely.


## 📂 How to Use

### 1️⃣ Fork This Repository
- Click the **Fork** button in the top-right corner to create your own copy.

### 2️⃣ Open the Repository in GitHub Codespaces
- Navigate to your forked repository.
- Click **Code > Open with Codespaces** to start your Codespace.

### 3️⃣ Run the Setup Script
1. Open the **Terminal** in your Codespace.
2. Make the script executable:
   ```bash
   chmod +x setup.sh
   ```
3. Run the setup script:
   ```bash
   ./setup.sh
   ```
4. Follow the prompts to choose your desktop environment.


## 🖥️ Desktop Environments Available

During installation, you can choose from the following desktop environments:

1. **GNOME**
2. **KDE Plasma**
3. **XFCE**
4. **Cinnamon**
5. **MATE**
6. **LXQt**
7. **Budgie**
8. **Deepin**
9. **Pantheon**

The script will install the selected DE along with all required components.

---

## 🌐 Access Your Desktop

After setup, access the desktop environment using the browser-based **noVNC** client:

1. Start the VNC server:
   ```bash
   vncserver :1
   ```
2. Start noVNC:
   ```bash
   websockify -D --web=/usr/share/novnc/ --cert=$HOME/novnc.pem 6081 localhost:5901
   ```
3. Open the browser and navigate to:
   ```
   https://<your-codespace-url>:6081
   ```
4. Enter your VNC password when prompted.

---

## 🔄 Re-entering Your Codespace

GitHub Codespaces automatically stops after 1 hour of inactivity. When restarting, follow these steps:

1. Kill any existing VNC session:
   ```bash
   vncserver -kill :1
   ```
2. Restart the VNC server:
   ```bash
   vncserver :1
   ```
3. Restart noVNC:
   ```bash
   websockify -D --web=/usr/share/novnc/ --cert=$HOME/novnc.pem 6081 localhost:5901
   ```

---

## 📖 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! If you have ideas for improvements or new features, feel free to open an issue or submit a pull request.

---

## 🌟 Showcase Your Setup

If you've used this script to set up your Codespace desktop, share a screenshot or feedback! We'd love to see what you've built.

```

