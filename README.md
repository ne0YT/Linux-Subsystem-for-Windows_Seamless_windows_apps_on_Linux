If seamless mode does not work: Turn off Nested Paging in the System tab and restart the guest.

# Run any Windows App seamlessly on Linux! Just click on the File and choose "open with Windows" or "Always open with Windows"!

### Windows Subsystem for Linux (WSL) BUT the other way around. Just like the name would suggest...

---
**Important: Global Usage and Password File**

- If you want to use `windows.sh` globally (from anywhere), the installer will create a symlink in `/usr/bin` pointing to the script in your project directory. **Do not move or rename the project folder after installation unless you re-run the installer or recreate the symlink.**
- The password file (`vm_password.txt`) is always read from the project directory, not from your current working directory.
- If you move the project folder, you must re-run the installer to update the symlink.
---

**Demo:** https://www.youtube.com/watch?v=QweFIyhDcMY&t=100s

This works very well using "tiny11" from NTDEV or the "Superlite compact" version of Windows.
These very small Windows installations that have removed some features.

No need to worry anymore that "this one tool for work" doesn't run on your Linux Machine! Now it will, just like if it was a native app… and this without many resources wasted or a complicated setup! Also, thanks to snapshots, you can easily revert any changes and startup the VM after a reboot extremely quickly!

I tested this using Xubuntu & Kubuntu 20.04, but it should work on any Linux system. The installation script automatically detects and supports:
- Arch-based systems (CachyOS, Manjaro, etc.) - uses pacman
- Debian-based systems (Ubuntu, etc.) - uses apt
- Fedora-based systems - uses dnf

For games, I still use Steams Proton. But for Business apps, I just use this setup.

Because it's a very **small VM** (iso install size without software is about **3.7 GB ("tiny10 23h1 x64")**) you can just sync/move it between your Linux Computers without any additional setup or special config!

**Requirements:**

Windows 11 VM on Virtualbox with the name "w11" and a user "admin" with a password stored in `vm_password.txt` file.

**Password Setup:**
Create a file named `vm_password.txt` in the project directory with your VM password on a single line. This file is excluded from version control for security (see `.gitignore`).

**VM Configuration:**
The VM needs to have guest-tools installed. The shared folder will be automatically configured during installation, creating the "Z:" drive in Windows automatically.

**Note:** If the VM is running during installation, a transient shared folder will be created (temporary). For a permanent shared folder, shut down the VM before running the installation script.

If you are worried about permanently mounting the root of the host Linux system in Windows in read/write mode because of security reasons, you can pause root folder mounting later (see **umountRoot** section for details).

Additional tips for tuning VM-interacting experience (for true "seamlessness"):
1. Add the attached **"disable_taskbar.cmd"** to the startup-folder.
Press Win+R and then type: ```shell:startup```
2. Configure the VM to automatically shut down when you click the close button in the virtual machine window decorator instead of asking what you want to do.
    - Run from Linux host terminal: ```VBoxManage setextradata 'w11' GUI/DefaultCloseAction Shutdown```.
    - In Windows 11 VM go to Control Panel -> Power Options -> System settings -> When I press the power button -> Choose "Shut down".
    - Reboot (for applying VBox setting).

**Setup:**

Just run this in a terminal:
```
git clone https://github.com/ne0YT/Linux-Subsystem-for-Windows_Seamless_windows_apps_on_Linux
cd Linux-Subsystem-for-Windows_Seamless_windows_apps_on_Linux/
sudo bash ./install_LSW.sh
```

The installation script will automatically:
- Install required dependencies (VirtualBox, wmctrl)
- Configure the shared folder for your VM
- Set up VM auto-shutdown behavior
- Check for password file
- Install desktop applications

**VM Auto-Start:** The system automatically starts the VM when you open a file, whether it's powered off or in a saved state.

**Testing:** Always use `./windows.sh README.md` to test the system. The script runs in ~0.3 seconds and exits immediately.

**Seamless Mode:** The installation script configures seamless mode settings. To enable seamless mode:
- Start the VM
- Go to View -> Seamless Mode in VirtualBox
- Or press Host+L to toggle seamless mode

**SaveWindows -App:**

If you set this up as I did, there's not too much overhead and the VM only restores/starts as soon as you open the first "run with Windows-File".
In addition to this, in order to improve performance further, the program ```SaveWindows``` saves the state of the w11-VM, and restarts it when needed, so you can temporarily use your full performance on Linux.

**umountRoot:**

Since giving Windows read/write access to the root of the host Linux system is not secure, or if you are paranoid about Windows tracking, you can pause mounting the root of the host system. To do this, run ```umountRoot``` from your DE menu.
It will then be mounted again the next time you run any file using "run with Windows-File".

**powershell.exe.lnk:**

Launch Powershell (need to be opened "using Windows")

**uninstall_LSW.sh:**

If you want to remove this great Tool.. just run ```uninstall_LSW.sh```
