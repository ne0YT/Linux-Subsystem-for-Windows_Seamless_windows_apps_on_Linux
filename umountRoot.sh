#!/bin/bash

# Get password from file
PASSWORD_FILE="$(dirname "$0")/vm_password.txt"
if [ ! -f "$PASSWORD_FILE" ]; then
    echo "Password file not found: $PASSWORD_FILE"
    echo "Please create vm_password.txt with your VM password"
    exit 1
fi
VM_PASSWORD=$(cat "$PASSWORD_FILE" | tr -d '\n\r')

vboxmanage guestcontrol "w11" run --username admin --password "$VM_PASSWORD" \
--wait-stdout --exe "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -- "net use /delete z:"
