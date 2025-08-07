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
cat > /usr/share/applications/Windows.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Windows
Comment=Open with Windows VM
Exec=/usr/bin/windows.sh %f
Icon=virt-manager
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

# Configure shared folder for VM
echo ""
echo "Configuring shared folder for VM 'w11'..."
# Get the current user who is running sudo
CURRENT_USER=${SUDO_USER:-$USER}

if sudo -u "$CURRENT_USER" VBoxManage showvminfo "w11" >/dev/null 2>&1; then
    # Remove existing shared folder if it exists
    sudo -u "$CURRENT_USER" VBoxManage sharedfolder remove "w11" --name "ROOT" >/dev/null 2>&1
    
    # Check if VM is running
    if sudo -u "$CURRENT_USER" VBoxManage showvminfo "w11" | grep -q "running"; then
        echo "VM 'w11' is running. Adding transient shared folder..."
        sudo -u "$CURRENT_USER" VBoxManage sharedfolder add "w11" --name "ROOT" --hostpath "/" --automount --transient
        echo "Transient shared folder 'ROOT' configured successfully for running VM 'w11'"
        echo "Note: This shared folder will be lost when the VM is restarted"
        echo "For permanent shared folder, shut down the VM and run the installation again"
    else
        # Add permanent shared folder
        sudo -u "$CURRENT_USER" VBoxManage sharedfolder add "w11" --name "ROOT" --hostpath "/" --automount
        echo "Permanent shared folder 'ROOT' configured successfully for VM 'w11'"
    fi
    echo "This will create the 'Z:' drive in Windows automatically"
else
    echo "Warning: VM 'w11' not found. Please create the VM first or update the VM name in the scripts."
    echo "You can manually configure the shared folder later using:"
    echo "VBoxManage sharedfolder add 'w11' --name 'ROOT' --hostpath '/' --automount"
fi

# Configure VM auto-shutdown behavior
echo ""
echo "Configuring VM auto-shutdown behavior..."
sudo -u "$CURRENT_USER" VBoxManage setextradata 'w11' GUI/DefaultCloseAction Shutdown
echo "VM will now automatically shut down when you close the window."

# Configure seamless mode settings
echo ""
echo "Configuring seamless mode settings..."
sudo -u "$CURRENT_USER" VBoxManage setextradata 'w11' GUI/Seamless on
sudo -u "$CURRENT_USER" VBoxManage setextradata 'w11' GUI/ShowMiniToolBar on
sudo -u "$CURRENT_USER" VBoxManage setextradata 'w11' GUI/Seamless on
sudo -u "$CURRENT_USER" VBoxManage setextradata 'w11' GUI/ShowMiniToolBar on
echo "Seamless mode will be enabled when VM starts."
echo "Note: You may need to manually enable seamless mode in VirtualBox GUI:"
echo "  - Start the VM"
echo "  - Go to View -> Seamless Mode"
echo "  - Or press Host+L to toggle seamless mode"

# Add disable_taskbar.cmd to Windows startup
echo ""
echo "Adding taskbar disable script to Windows startup..."
if [ -f "disable_taskbar.cmd" ]; then
    # Copy the script to Windows startup folder
    sudo -u "$CURRENT_USER" VBoxManage --nologo guestcontrol "w11" run --username admin --password "$(cat vm_password.txt | tr -d '\n\r')" \
    --wait-stdout --exe "C:\Windows\System32\cmd.exe" -- "/c copy \"Z:\\home\\user\\Documents\\Projects\\Linux-Subsystem-for-Windows_Seamless_windows_apps_on_Linux\\disable_taskbar.cmd\" \"%APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\""
    echo "Taskbar disable script added to Windows startup folder."
else
    echo "Warning: disable_taskbar.cmd not found. Please add it manually to Windows startup."
fi

echo ""
echo "=== Installation completed successfully! ==="
echo ""
echo "Next steps:"
echo "1. Create vm_password.txt with your VM password if not already done"
echo "2. Right-click any file and select 'Open with Windows' to test"
echo "3. Use 'SaveWindows' app to save VM state when not in use"
echo "4. Use 'UmountRoot' to temporarily unmount the root directory for security"
