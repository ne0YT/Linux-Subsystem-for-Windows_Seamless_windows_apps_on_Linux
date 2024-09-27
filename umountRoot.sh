#!/bin/bash

vboxmanage guestcontrol "win10" run --username admin --password RALFqxAbLDEdFfVdgXjPD2Yvk3uqjT4JG8V9yVhrkBAD8jpRjwh4dZmtMxpdHGAn \
--wait-stdout --exe "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -- "net use /delete z:"
