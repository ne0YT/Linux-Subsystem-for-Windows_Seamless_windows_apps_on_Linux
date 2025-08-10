#!/bin/bash

# Ultra-fast file opening script for Windows VM
if [ "$#" -ne 1 ]; then
   exit 1
fi

# Always resolve password file relative to the real script location (even if symlinked)
SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
PASSWORD_FILE="$SCRIPT_DIR/vm_password.txt"
if [ ! -f "$PASSWORD_FILE" ]; then
    echo "Password file not found: $PASSWORD_FILE"
    echo "Please create vm_password.txt with your VM password"
    exit 1
fi
VM_PASSWORD=$(cat "$PASSWORD_FILE" | tr -d '\n\r')

# Quick VM start if not running (non-blocking)
if ! VBoxManage showvminfo "w11" | grep -q "running"; then
    VBoxManage startvm "w11" --type separate > /dev/null 2>&1 &
fi

# Ensure transient shared folder ROOT exists when VM is running (creates Z:)
if VBoxManage showvminfo "w11" | grep -q "running"; then
    VBoxManage sharedfolder add "w11" --name "ROOT" --hostpath "/" --automount --transient > /dev/null 2>&1 || true
fi

# Convert path and open file immediately (forward slashes for Windows)
ABSOLUTE_PATH=$(realpath "$1" 2>/dev/null)
if [ -z "$ABSOLUTE_PATH" ]; then
    exit 1
fi
WINDOWS_PATH=$(echo "$ABSOLUTE_PATH" | sed 's|^/|Z:/|' | sed 's|/|/|g')

# Open file with fastest method (cmd.exe in background)
VBoxManage --nologo guestcontrol "w11" run --username admin --password "$VM_PASSWORD" \
--exe "C:\Windows\System32\cmd.exe" -- "/c start $WINDOWS_PATH" > /dev/null 2>&1 &
