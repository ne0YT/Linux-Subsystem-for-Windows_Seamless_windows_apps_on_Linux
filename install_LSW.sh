#!/bin/bash
# only root can run this script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "=== Linux Subsystem for Windows Installation ==="
echo ""

# Detect package manager and install dependencies
echo "Installing required dependencies..."
if command -v pacman >/dev/null 2>&1; then
    # Arch-based system (CachyOS, Manjaro, etc.)
    echo "Detected Arch-based system, using pacman..."
    pacman -Sy --noconfirm virtualbox wmctrl
    echo "Dependencies installed successfully!"
elif command -v apt >/dev/null 2>&1; then
    # Debian-based system (Ubuntu, etc.)
    echo "Detected Debian-based system, using apt..."
    apt update
    apt install -y virtualbox wmctrl
    echo "Dependencies installed successfully!"
elif command -v dnf >/dev/null 2>&1; then
    # Fedora-based system
    echo "Detected Fedora-based system, using dnf..."
    dnf install -y VirtualBox wmctrl
    echo "Dependencies installed successfully!"
else
    echo "Warning: Could not detect package manager. Please install virtualbox and wmctrl manually."
fi

echo ""
echo "Copying files and setting permissions..."

# copying files + setting permissions
rm -f /usr/bin/windows.sh
ln -s "$(pwd)/windows.sh" /usr/bin/windows.sh
chmod +x /usr/bin/windows.sh
# Always create a fresh Windows.desktop with correct Exec line
# Use new icons for launchers
# Get the actual script directory (where the files are located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set icon paths to use only icons/ subfolder
WINDOWS_ICON="$SCRIPT_DIR/icons/windows.png"
POWERSHELL_ICON="$SCRIPT_DIR/icons/powershell.png"

# Create Windows launcher
cat > /usr/share/applications/Windows.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Windows
Comment=Open with Windows VM
Exec=/usr/bin/windows.sh %f
Icon=$WINDOWS_ICON
Path=
Terminal=false
StartupNotify=false
Categories=Utility
EOF
chmod +x /usr/share/applications/Windows.desktop
\cp ./savewindows.sh /usr/bin/
chmod +x /usr/bin/savewindows.sh
\cp ./SaveWindows.desktop /usr/share/applications/
chmod +x /usr/share/applications/SaveWindows.desktop
\cp ./umountRoot.sh /usr/bin/
chmod +x /usr/bin/umountRoot.sh
\cp ./UmountRoot.desktop /usr/share/applications/
chmod +x /usr/share/applications/UmountRoot.desktop

# Copy powershell-as-admin.cmd to /usr/bin/
\cp ./powershell-as-admin.cmd /usr/bin/
chmod +x /usr/bin/powershell-as-admin.cmd

# Create Powershell in Windows launcher
cat > /usr/share/applications/PowershellInWindows.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Powershell in Windows
Comment=Open Powershell in Windows VM
Exec=wmctrl -xa Windows || /usr/bin/windows.sh powershell.exe
Icon=$POWERSHELL_ICON
Path=
Terminal=false
StartupNotify=false
Categories=Utility
EOF
chmod +x /usr/share/applications/PowershellInWindows.desktop

# Create Powershell as Admin in Windows launcher
cat > /usr/share/applications/PowershellAsAdminInWindows.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Powershell as Admin in Windows
Comment=Open Powershell as Administrator in Windows VM
Exec=wmctrl -xa Windows || /usr/bin/windows.sh $SCRIPT_DIR/powershell-as-admin.cmd
Icon=$POWERSHELL_ICON
Path=
Terminal=false
StartupNotify=false
Categories=Utility
EOF
chmod +x /usr/share/applications/PowershellAsAdminInWindows.desktop

# Update Apps without logout
update-desktop-database /usr/share/applications/

echo "Files installed successfully!"

# Check for password file
echo ""
echo "Checking password file..."
if [ ! -f "vm_password.txt" ]; then
    echo "Password file 'vm_password.txt' not found."
    echo "Please create this file with your VM password before using the system."
    echo "Example: echo 'your_password_here' > vm_password.txt"
else
    echo "Password file found."
fi

echo ""
echo "Skipping VirtualBox VM configuration in base install."
echo "Run ./configure_virtualbox.sh to set up VM integration (shared folder, seamless mode, taskbar)."

echo ""
echo "=== Installation completed successfully! ==="
echo ""
echo "Next steps:"
echo "1. Create vm_password.txt with your VM password if not already done"
echo "2. Right-click any file and select 'Open with Windows' to test"
echo "3. Use 'SaveWindows' app to save VM state when not in use"
echo "4. Use 'UmountRoot' to temporarily unmount the root directory for security"
