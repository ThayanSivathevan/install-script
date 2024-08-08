Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object Windows.Forms.Form
$form.Text = "Shutdown Countdown"
$form.Size = New-Object Drawing.Size(500, 200)
$form.StartPosition = "CenterScreen"

# Create the label
$label = New-Object Windows.Forms.Label
$label.Text = ""
$label.AutoSize = $true
$label.Font = New-Object Drawing.Font("Arial", 14)
$label.Location = New-Object Drawing.Point(50, 50)

# Create the button
$button = New-Object Windows.Forms.Button
$button.Text = "Reset Timer"
$button.Location = New-Object Drawing.Point(210, 100)
$button.AutoSize = $true

# Create the notify icon
$notifyIcon = New-Object System.Windows.Forms.NotifyIcon
$notifyIcon.Icon = [System.Drawing.SystemIcons]::Information
$notifyIcon.Visible = $true

function Center-Items {
    param (
        [System.Windows.Forms.Label]$label,
        [System.Windows.Forms.Form]$form
    )
    $label.Left = ($form.ClientSize.Width - $label.Width) / 2
    $button.Left = ($form.ClientSize.Width - $button.Width)/ 2
}

function Update-Label {
    param (
        [int]$timeLeft
    )
    $minutes = [math]::Floor($timeLeft / 60)
    $seconds = $timeLeft % 60
    $label.Text = "Shutting down in $minutes minutes and $seconds seconds"
    Center-Items -label $label -form $form
}

# Function to show notifications
function Show-Notification {
    param (
        [string]$message
    )
    $notifyIcon.BalloonTipText = $message
    $notifyIcon.ShowBalloonTip(10000)  # Show for 10 seconds
}

# Add controls to the formn
$form.Controls.Add($label)
$form.Controls.Add($button)

# Timer settings
$initalTime = 5
$totalTime = $initalTime  # Total time in seconds (1 hour)
$interval = 1      # Interval in seconds

# Create the timer
$timer = New-Object Windows.Forms.Timer
$timer.Interval = $interval * 1000

$notificationTimes = @(3599, 1800, 600, 300, 60, 30, 25, 20, 15, 10, 5, 1)
$notifiedTimes = @{}

# Timer tick event
$timer.Add_Tick({
    if ($totalTime -le 0) {
        $timer.Stop()
        Stop-Computer -Force
    } else {
        $script:totalTime -= $interval
        Update-Label -timeLeft $script:totalTime
        foreach ($notificationTime in $notificationTimes) {
            if ($script:totalTime -eq $notificationTime -and -not $notifiedTimes.Contains($notificationTime)) {
                Show-Notification "$([math]::Floor($notificationTime / 60)) minutes and $($notificationTime % 60) second(s) left before shutdown"
                $notifiedTimes += $notificationTime
            }
        }
    }
})

# Button click event to reset the timer
$button.Add_Click({
    $script:totalTime = $initalTime  # Reset to 1 hour
    Update-Label -timeLeft $script:totalTime
    $notifiedTimes.Clear()
})

# Form load event to start the timer
$form.Add_Load({
    $timer.Start()
    Update-Label -timeLeft $script:totalTime
})

$form.Add_FormClosing({
    $timer.Stop()
    $notifiedTimes.Clear()
})
# Show the form
[void]$form.ShowDialog()
