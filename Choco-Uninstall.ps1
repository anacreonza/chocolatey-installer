# Script to remove chocolately from client
$ChocoDir = "c:\ProgramData\Chocolatey\"
$ChocoPath = $ChocoDir + "choco.exe"
$ChocoGUIPath = "C:\Program Files (x86)\Chocolatey GUI\Chocolateygui.exe"

# Uninstall chocolateygui
if (Test-Path $ChocoGUIPath){
    choco uninstall chocolateygui -y
}
# Uninstall chocolately itself
if (Test-Path $ChocoPath){
    Write-Host "Removing Chocolatey folder..."
    Remove-Item -Path $ChocoDir -Force -Recurse
}

# Remove scheduled task
$taskName = "ChocoUpgradeAll"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName }
if ($taskExists){
    Write-Host "Removing Chocolatey scheduled task..."
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$False
}
Write-Host "Done." -ForegroundColor Green
Start-Sleep -Seconds 4