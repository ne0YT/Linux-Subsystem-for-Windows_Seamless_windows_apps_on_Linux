# # Check that we have got the correct number of parameters.
#
if [ "$#" -ne 1 ]; then
   echo "The run in Windows-script requires one parameter to be passed!"
   exit
fi

#
# Check if the file exists in the host file system in case we are
# called from a terminal.
#
if [ ! -f "$1" ]; then
   echo "File not found in the host file system!"
   echo 'Make sure the file' $1 'exists!'
   exit
fi

#start Vm
# CHANGE "win10" to your VM name
if !( vboxmanage showvminfo "win10" | grep -c "running (since" ); then
    vboxmanage startvm "win10" --type separate > /dev/null
    sleep 10 # change this if your Windows is loading faster
    #echo "start"
fi

# Move focus to VM instance window (works for me on Linux Mint XFCE, if not working for you, you can adapt other solutions for your DE: https://superuser.com/questions/142945/bash-command-to-focus-a-specific-window)
wmctrl -a win10

VBoxManage --nologo guestcontrol "win10" run --username admin --password RALFqxAbLDEdFfVdgXjPD2Yvk3uqjT4JG8V9yVhrkBAD8jpRjwh4dZmtMxpdHGAn \
--wait-stdout --exe "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -- "net use z: \\\\vboxsvr\\ROOT"

#
# Make a new executable file having WINDOWS_PATH as argument at the end of
# VBoxManage command and write the command string in it.
#
mkdir ~/.tmp > /dev/null 2>&1
cd ~/.tmp
#rm tmpfile
touch tmpfile
chmod +x tmpfile
# CHANGE windows username (no password!)
cmd=(VBoxManage --nologo guestcontrol "win10" run --username admin --password RALFqxAbLDEdFfVdgXjPD2Yvk3uqjT4JG8V9yVhrkBAD8jpRjwh4dZmtMxpdHGAn \
--wait-stdout --exe 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe' -- '"& \"Z:\\'${1}'\""')
echo "${cmd[@]}" >> tmpfile

#
# Run the commands in tmpfile for opening the clicked file!
#
./tmpfile &
# Add delay, since sometimes tmpfile file gets deleted before it starts executing
sleep 0.2
rm tmpfile
