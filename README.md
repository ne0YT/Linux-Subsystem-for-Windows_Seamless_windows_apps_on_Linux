# Run any Windows App seamlessly on Linux! Just click on the File and chose "open with Windows" or "Always open with Windows"!

### Windows Subsystem for Linux (WSL) BUT the other way around. Just like the name would suggest..

**Demo:**
https://www.youtube.com/watch?v=QweFIyhDcMY&t=100s

this works very well using tiny10 from NTDEV.. (very small windows-install)

no need to worry anmyore that "this one Tool for work" doesn't run on your Linux Machine! Now it will, just like if it was a native app.. and this without much resources wasted or a complicated setup! Also thanks to snapshots you can easily revert any changes and startup the VM after a reboot extremely quickly!

I tested this using Xubuntu & Kubuntu 20.04 but it should work on any -nix-System

For Games I still use Steams Proton. But for Business apps I just use this setup.

because it's a very **small VM** (Install size without software is about **2.8 GB (64bit W10)**) you can just synch/move it between your Linux Computers without any additional setup or special config!

**Requirement:**
Windows 10 VM on Virtualbox with the name "win10" and a user "admin" with the password:
```
RALFqxAbLDEdFfVdgXjPD2Yvk3uqjT4JG8V9yVhrkBAD8jpRjwh4dZmtMxpdHGAn
```

**Setup:**
Just run this in a terminal:
```
git clone https://github.com/ne0YT/Linux-Subsystem-for-Windows_Seamless_windows_apps_on_Linux
cd Linux-Subsystem-for-Windows_Seamless_windows_apps_on_Linux/
sudo bash ./install_LSW.sh
```

**SaveWindows -App:**
If you set this up as I did there's not to much overhead and the VM only restores/starts as soon as you open the first "run with Windows-File".. but still..
This App saves the state of the win10-VM so you can temporarily use your full performance on Linux
