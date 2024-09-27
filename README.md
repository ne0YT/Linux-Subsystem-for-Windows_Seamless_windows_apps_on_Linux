# Run any Windows App seamlessly on Linux! Just click on the File and chose "open with Windows" or "Always open with Windows"!

### Windows Subsystem for Linux (WSL) BUT the other way around. Just like the name would suggest...

**Demo:**
https://www.youtube.com/watch?v=QweFIyhDcMY&t=100s

This works very well using "tiny10" from NTDEV or the "Superlite compact" version of Windows.
These very small Windows installations that have removed some features.

No need to worry anymore that "this one tool for work" doesn't run on your Linux Machine! Now it will, just like if it was a native app… and this without many resources wasted or a complicated setup! Also, thanks to snapshots, you can easily revert any changes and startup the VM after a reboot extremely quickly!

I tested this using Xubuntu & Kubuntu 20.04, but it should work on any -nix-System

For games, I still use Steams Proton. But for Business apps, I just use this setup.

Because it's a very **small VM** (Install size without software is about **2.8 GB (64bit W10 "tiny10")**) you can just synch/move it between your Linux Computers without any additional setup or special config!

**Requirement:**
Windows 10 VM on Virtualbox with the name "win10" and a user "admin" with the password:
```
RALFqxAbLDEdFfVdgXjPD2Yvk3uqjT4JG8V9yVhrkBAD8jpRjwh4dZmtMxpdHGAn
```
The VM needs to have guest-tools installed, and you need to add the shared folder like this:
```
Path:
\
Name:
ROOT
+ Tick "Auto-Mount"
```
This will create the "Z:" Drive in Windows automatically! Otherwise, there's an issue with the guest tools.
But if you are worried about permanently mounting the root of the host Linux system in Windows in read/write mode because of security reasons, you can uncheck this box later (see “umountRoot” section).

Additional tip (for true "seamlessness"):
Add the attached **"disable_taskbar.cmd"** to the startup-folder.
Press Win+R and then type: ```shell:startup```

**Setup:**
Just run this in a terminal:
```
git clone https://github.com/ne0YT/Linux-Subsystem-for-Windows_Seamless_windows_apps_on_Linux
cd Linux-Subsystem-for-Windows_Seamless_windows_apps_on_Linux/
sudo bash ./install_LSW.sh
```

**SaveWindows -App:**
If you set this up as I did, there's not too much overhead and the VM only restores/starts as soon as you open the first "run with Windows-File".
In addition to this, in order to improve performance further, the program ```SaveWindows``` saves the state of the win10-VM, and restarts it when needed, so you can temporarily use your full performance on Linux.

**umountRoot**
Since giving Windows read/write access to the root of the host Linux system is not secure, or if you are paranoid about Windows tracking, you can pause mounting the root of the host system.
It will then be mounted again the next time you run any file using "run with Windows-File".

**powershell.exe.lnk:**
Launch Powershell (need to be opened "using Windows")

**uninstall_LSW.sh:**
If you want to remove this great Tool.. just run "uninstall_LSW.sh"
