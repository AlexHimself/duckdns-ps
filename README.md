

# duckdns-ps

DuckDNS PowerShell will create a Windows Scheduled task to automatically update DuckDNS.org and it can be installed/uninstalled with one command!

## Requirements
- PowerShell 5.1

## Windows Versions this script is supported out of the box with

* Windows 10 and higher
* Windows Server 2016 and higher
* Any version of windows with PowerShell 5.1 installed

# Install/Update/Uninstall

Choose one of the two easy methods below to start the install/update/uninstall process.

If you already have the scheduled task created you will be prompted to uninstall first, and then you can choose to continue installing or exit.

## Method 1 (easy)

From an **ELEVATED** (_run as administrator_) PowerShell prompt run the following command:

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/AlexHimself/duckdns-ps/main/DuckDNS-Updater.ps1'))

## Method 2 (almost as easy)

Download and run `DuckDNS-Updater.ps1` manually as adminstrator.

## Next Steps
You will then be prompted to enter the following:

 - Domain(s) to update
 - DuckDNS token
 - Frequency in minutes to update
 - IPv4 address you would like to use, or blank to detect automatically

![image](https://github.com/AlexHimself/duckdns-ps/assets/10466466/355da81a-7a6c-4f11-ad57-ad2c7c0b3bf1)


## Done! - Verify 
To verify, open Windows Task Scheduler by either:

**1.** Open task scheduler by -
- Win+R (run): taskschd.msc
OR
- Pressing the windows key and searching "Task Scheduler"

**2.** Confirm a new task `DuckDNS.org` exists!

## Manual Uninstall
Open the task scheduler by following the steps above and right click and delete the `DuckDNS.org` scheduled task.
