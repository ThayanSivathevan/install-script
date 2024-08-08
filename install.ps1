# Define task name and description
$taskName = "MyPowerShellScriptTask"
$taskDescription = "Runs a PowerShell script at startup with highest privileges and on demand"

# Define the action to run the PowerShell script
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File C:\install-script.ps1"

# Define the trigger to run the task at startup
$trigger = New-ScheduledTaskTrigger -AtStartup

# Define the principal to run with highest privileges
$principal = New-ScheduledTaskPrincipal -UserId "Administrator" -LogonType ServiceAccount -RunLevel Highest

# Define the settings for the task
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Create the scheduled task
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings -Description $taskDescription

# Register the scheduled task
Register-ScheduledTask -TaskName $taskName -InputObject $task -Force

# Optional: Add permission to run on demand
Set-ScheduledTask -TaskName $taskName -User "Everyone" -RunLevel Highest
