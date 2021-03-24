# Script to install and configure a Choco client
$ChocoPath = "c:\ProgramData\Chocolatey\choco.exe"
$ChocoGUIPath = "C:\Program Files (x86)\Chocolatey GUI\Chocolateygui.exe"

# Install Chocolatey client
if (-Not (Test-Path $ChocoPath)){
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install ChocolateyGUI
if (-Not (Test-Path $ChocoGUIPath)){
    choco install chocolateygui -y
}

# Add repo
choco source add -n="test-repository" -s="http://02cpt-fwslab01.m24.media24.com:8081/repository/test-repository/"

# Create scheduled task to run choco upgrade all regularly
$taskName = "ChocoUpgradeAll"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }
if (-Not ($taskExists)){
    Write-Host "Installing Chocolatey scheduled task..."
    $argument = "upgrade all -y"
    $action = New-ScheduledTaskAction -Execute $ChocoPath -Argument $argument
    $trigger = New-ScheduledTaskTrigger -AtLogon
    $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description "Upgrades all currently installed choco packages." -Principal $principal
}
Write-Host "Done." -ForegroundColor Green
Start-Sleep -Seconds 5