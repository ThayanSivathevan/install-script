# Define the path to the PowerShell script you want to run
$scriptPath = "C:\Path\To\YourScript.ps1"

# Create a daily trigger at a specific time (e.g., 3:00 PM)
$trigger = New-ScheduledTaskTrigger -Daily -At 3:00PM

# Create an action to run the PowerShell script
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -File `"$scriptPath`""

# Optionally, create a principal (user) under which the task will run
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount

# Define the task settings (optional)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable

# Register the scheduled task
Register-ScheduledTask -TaskName "My PowerShell Script Task" -Trigger $trigger -Action $action -Principal $principal -Settings $settings

Write-Output "Scheduled task created successfully."

