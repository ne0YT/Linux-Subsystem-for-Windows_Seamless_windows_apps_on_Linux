#!/bin/bash
# only root can run this script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
# copying files + setting permissions
\cp ./windows.sh /usr/bin/
chmod +x /usr/bin/windows.sh
\cp ./Windows.desktop /usr/share/applications/
chmod +x /usr/share/applications/Windows.desktop
