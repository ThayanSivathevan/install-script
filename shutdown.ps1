$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
$filePath = "$scriptDirectory\RemainingTime.txt"
$tempFilePath = "$scriptDirectory\RemainingTime.tmp"
$resetFilePath = "$scriptDirectory\ResetSignal.txt"
$initialTime = 3600  # Total time in seconds (1 hour)
$interval = 1  # Interval in seconds
$totalTime = $initialTime

# Remove reset file if it exists
if (Test-Path $resetFilePath) {
    Remove-Item $resetFilePath
}

while ($true) {
    if (Test-Path $resetFilePath) {
        Remove-Item $resetFilePath
        $totalTime = $initialTime
    }

    if ($totalTime -le 0) {
        Stop-Computer -Force
    } else {
        $totalTime -= $interval
        $minutes = [math]::Floor($totalTime / 60)
        $seconds = $totalTime % 60
        $remainingTime = "$minutes $seconds"
        Set-Content -Path $tempFilePath -Value $remainingTime
        Move-Item -Path $tempFilePath -Destination $filePath -Force
        Start-Sleep -Seconds $interval
    }
}
