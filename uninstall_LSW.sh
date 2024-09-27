#!/bin/bash
# only root can run this script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
# remove all Files
echo "This will remove all files from LSW"
echo "It will NOT delete or modify your Windows-VM"
rm -f /usr/bin/windows.sh
rm -f  /usr/share/applications/Windows.desktop
rm -f /usr/bin/savewindows.sh
rm -f /usr/share/applications/SaveWindows.desktop
rm -f /usr/bin/umountRoot.sh
rm -f /usr/share/applications/UmountRoot.desktop
