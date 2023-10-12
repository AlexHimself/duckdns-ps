#Requires -Version 5.1

#region Validation Functions
Function ValidateYesNo {
    [OutputType([string])]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("yes", "y", "no", "n")]
        [string]$value
    )
    switch ($value) {
        { @("yes", "y") -contains $_} { return $true }
        default { return $false }
    }
}

Function ValidateString {
    Param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$value
    )
    return $value
}

Function ValidateMinutes {
    Param(
    [Parameter(Mandatory=$true)]
    [ValidateRange(1,86399)]
    [int]$value
    )
    return $value
}

Function ValidateToken {
    Param(
    [Parameter(Mandatory=$true)]
    [ValidatePattern("^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$")]
    [guid]$value
    )
    return $value
}

Function ValidateIP {
    Param(
    [Parameter(Mandatory=$false)]
    [ValidatePattern("^$|^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$")]
    [string]$value
    )
    return $value
}
#endregion

#region Initial Variables
$setupDuckDNSTask = $true
$ErrorActionPreference = "Stop"
$taskName = "DuckDNS.org"
#endregion

# 84b56fff-4e73-4311-ace0-75dc985e825a

# First check if scheduled task already exists
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    # See if user wants to remove it
    if (ValidateYesNo (Read-Host "Existing DuckDNS task found. Would you like to remove it? (Y/N)")) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false

        Write-Host "$($taskName) scheduled task was removed."
        # Check if user wants to continue setup
        $setupDuckDNSTask = ValidateYesNo (Read-Host "Would you like to continue setting up a new DuckDNS task? (Y/N)")
    } else {
        # User did not want to remove it. Do nothing.
        $setupDuckDNSTask = $false
        Write-Host "No action performed..."
    }
}

if ($setupDuckDNSTask) {
    $domains = ValidateString (Read-Host "Enter the domain(s) subname(s) you want to update. If more than one, separate by commas") -ErrorAction Stop
    $token = ValidateToken (Read-Host "Enter your DuckDNS Token") -ErrorAction Stop
    $minuteFrequency = ValidateMinutes (Read-Host "Enter the frequency in minutes to update DuckDNS") -ErrorAction Stop
    $ip = ValidateIP (Read-Host "Enter the IPv4 address or blank to detect") -ErrorAction Stop

    # Agument command that will be stored in the scheduled task action
    $command = "Invoke-RestMethod -Method Get -Uri ('https://www.duckdns.org/update?domains={0}&token={1}&ip={2}' -f '$($domains)', '$($token)', '$($ip)')"

    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval ([TimeSpan]::FromMinutes($minuteFrequency))

    $action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument $command

    Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -User "NT AUTHORITY\SYSTEM" -RunLevel Highest

    Write-Host "Created scheduled task '$($taskName)' that will run every $($minuteFrequency) updating the following domain(s): $($domains)"
}
