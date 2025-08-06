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

# Get password from file
PASSWORD_FILE="$(dirname "$0")/vm_password.txt"
if [ ! -f "$PASSWORD_FILE" ]; then
    echo "Password file not found: $PASSWORD_FILE"
    echo "Please create vm_password.txt with your VM password"
    exit 1
fi
VM_PASSWORD=$(cat "$PASSWORD_FILE" | tr -d '\n\r')

#start VM
# CHANGE "w11" to your VM name
if !( vboxmanage showvminfo "w11" | grep -c "running (since" ); then
    vboxmanage startvm "w11" --type separate > /dev/null
    sleep 10 # change this if your Windows is loading faster
    #echo "start"
fi

# Move focus to VM instance window (works for me on Linux Mint XFCE, if not working for you, you can adapt other solutions for your DE: https://superuser.com/questions/142945/bash-command-to-focus-a-specific-window)
wmctrl -a w11

VBoxManage --nologo guestcontrol "w11" run --username admin --password "$VM_PASSWORD" \
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
# CHANGE windows username (password from file)
cmd=(VBoxManage --nologo guestcontrol "w11" run --username admin --password "$VM_PASSWORD" \
--wait-stdout --exe 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe' -- '"& \"Z:\\'${1}'\""')
echo "${cmd[@]}" >> tmpfile

#
# Run the commands in tmpfile for opening the clicked file!
#
./tmpfile &
# Add delay, since sometimes tmpfile file gets deleted before it starts executing
sleep 0.2
rm tmpfile
