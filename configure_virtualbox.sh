#!/bin/bash

set -euo pipefail

# Only root can run this script
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

VM_NAME="w11"
CURRENT_USER=${SUDO_USER:-$USER}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Configure VirtualBox integration for VM '${VM_NAME}' ==="

if ! command -v VBoxManage >/dev/null 2>&1; then
  echo "Error: VBoxManage not found. Please install VirtualBox first." >&2
  exit 1
fi

if ! sudo -u "$CURRENT_USER" VBoxManage showvminfo "$VM_NAME" >/dev/null 2>&1; then
  echo "Error: VM '$VM_NAME' not found. Edit the script or pass the VM name as an argument." >&2
  exit 1
fi

# Shared folder ROOT -> Z:\
echo "Configuring shared folder ROOT -> / (Z:)"
# Remove both permanent and transient if present to avoid 'already exists'
sudo -u "$CURRENT_USER" VBoxManage sharedfolder remove "$VM_NAME" --name "ROOT" >/dev/null 2>&1 || true
sudo -u "$CURRENT_USER" VBoxManage sharedfolder remove "$VM_NAME" --name "ROOT" --transient >/dev/null 2>&1 || true
if sudo -u "$CURRENT_USER" VBoxManage showvminfo "$VM_NAME" | grep -q "running"; then
  echo "VM is running: adding transient shared folder"
  sudo -u "$CURRENT_USER" VBoxManage sharedfolder add "$VM_NAME" --name "ROOT" --hostpath "/" --automount --transient
  echo "Note: transient shared folder will be lost on reboot"
else
  echo "VM is powered off: adding permanent shared folder"
  sudo -u "$CURRENT_USER" VBoxManage sharedfolder add "$VM_NAME" --name "ROOT" --hostpath "/" --automount
fi

# GUI preferences
echo "Setting GUI preferences (Seamless + MiniToolbar + DefaultCloseAction=Shutdown)"
sudo -u "$CURRENT_USER" VBoxManage setextradata "$VM_NAME" GUI/Seamless on
sudo -u "$CURRENT_USER" VBoxManage setextradata "$VM_NAME" GUI/ShowMiniToolBar on
sudo -u "$CURRENT_USER" VBoxManage setextradata "$VM_NAME" GUI/DefaultCloseAction Shutdown

# Keep nested paging enabled
echo "Ensuring nested paging stays enabled (no change made here)"

# Copy and schedule taskbar disable script, and run once now
VM_PASSWORD_FILE="$SCRIPT_DIR/vm_password.txt"
if [ -f "$SCRIPT_DIR/disable_taskbar.cmd" ] && [ -f "$VM_PASSWORD_FILE" ]; then
  VM_PASSWORD=$(tr -d '\r\n' < "$VM_PASSWORD_FILE")
  STARTUP_DIR_WIN='C:\\Users\\admin\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup'
  echo "Copying disable_taskbar.cmd into Startup folder"
  sudo -u "$CURRENT_USER" VBoxManage --nologo guestcontrol "$VM_NAME" copyto "$SCRIPT_DIR/disable_taskbar.cmd" --username admin --password "$VM_PASSWORD" "$STARTUP_DIR_WIN\\disable_taskbar.cmd" --verbose || true

  echo "Trying to run disable_taskbar.cmd once now via cmd.exe"
  ATTEMPTS=0
  until sudo -u "$CURRENT_USER" VBoxManage --nologo guestcontrol "$VM_NAME" run --username admin --password "$VM_PASSWORD" --exe "C:\\Windows\\System32\\cmd.exe" -- "/c" "\"\"%APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\disable_taskbar.cmd\"\"" --verbose; do
    ATTEMPTS=$((ATTEMPTS+1))
    if [ $ATTEMPTS -ge 10 ]; then
      echo "Skipping: could not run script inside guest after multiple attempts"
      break
    fi
    echo "Waiting for guest control to be ready... ($ATTEMPTS/10)"
    sleep 3
  done
else
  echo "Note: Skipping taskbar disable step (missing disable_taskbar.cmd or vm_password.txt)"
fi

echo "All done. You may need to enable Seamless Mode from the GUI (Host+L)."

