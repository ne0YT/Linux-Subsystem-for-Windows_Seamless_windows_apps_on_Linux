Run any Windows App seamless on Linux!

Windows Subsystem for Linux (WSL) BUT the other way around. Just like the name would suggest..
it works very well using tiny10 from NTDEV

no need to worry anmyore that "this one Tool for work" doesn't run on your Linux Machine! Now it will, just like if it was a native app.. and this without much resources wasted or a complicated setup!

I tested this using Xubuntu & Kubuntu 20.04

For Games I still use Steams Proton. But for Business apps which don't work on the first try with wine or mono I just use this setup.

because it's a very small VM (Install size without software is about 2.8 GB (64bit W10)) you can just synch/move it between your Linux Computers without any additional setup or special wine config!

Requirement:
Windows 10 VM on Virtualbox with the name "win10" and a user "admin" with no password.
+ Enable no password in GPO

Setup:
Just run this in a terminal:
```
git clone https://github.com/ne0YT/Linux-Subsystem-for-Windows_Seamless_windows_apps_on_Linux
cd Linux-Subsystem-for-Windows_Seamless_windows_apps_on_Linux/
./install_LSW.sh
```

