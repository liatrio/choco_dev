# Powershell

# Choco install
#
# Allow internet sourced script execution of signed scripts
# TODO: Install choco script locally or install a choco cert to allow signed script execution
# Set-ExecutionPolicy AllSigned -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# TEMP: Bypass security verify and install choco from the internet.
# This is equivelent to curl | bash, prolly not the best.
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install some things
#
# choco install vscode -y
# choco install git -y
# OR

# Auto-confirm-yes always
choco feature enable -n allowGlobalConfirmation
choco install vscode
choco install git

# Disable/enable public source
#choco source enable --name chocolatey
choco source disable --name chocolatey

# Add internal package source
choco source add -n liatrio -s="https://artifactory.liatr.io/artifactory/api/nuget/choco-local"


# Make a new package
cd c:\
# Create a new package template 
choco new test2 -a --version 0.0.1 maintainername="'myusername'"


