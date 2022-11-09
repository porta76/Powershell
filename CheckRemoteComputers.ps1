function GetProcessorLoadOnRemote([String]$RemoteComputer) 
{
    $ProcessorLoad = Get-WmiObject Win32_Processor -ComputerName $RemoteComputer | Measure-Object -Property LoadPercentage -Average | Select Average
    Write-Host "Processor usage: " $ProcessorLoad
}

function GetTotalPhysicalOnRemote([String]$RemoteComputer) 
{
    $TotslPhysicalMemory = Get-WMIObject -Computername $RemoteComputer -class win32_ComputerSystem| Select-Object -Expand TotalPhysicalMemory
    $TotslPhysicalMemory = [Math]::Round($TotslPhysicalMemory / 1GB,2)
    Write-Host "Total physical memory (GB) " $TotslPhysicalMemory   
}

function GetMemoryUsageOnRemote([String]$RemoteComputer, [int]$Threshold) 
{
    $CompObject =  Get-WmiObject -Class WIN32_OperatingSystem -ComputerName $RemoteComputer  
    $Memory = [Decimal]((($CompObject.TotalVisibleMemorySize - $CompObject.FreePhysicalMemory)*100)/ $CompObject.TotalVisibleMemorySize)
    $Memory = [Math]::Round($Memory,2)
    Write-Host "Memory usage in Percentage: " -nonewline
    if ($Memory -gt $Threshold) {
       Write-Host  $Memory -ForegroundColor White -BackgroundColor Red
    } else {
       Write-Host $Memory  -ForegroundColor Green
    }      
}

function GetTopMemoryUsageOnRemote([String]$RemoteComputer, [int]$TopNr) 
{
    $processMemoryUsage = Get-WmiObject WIN32_PROCESS -ComputerName $RemoteComputer  | Sort-Object -Property ws -Descending | Select-Object -first $TopNr processname, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}| Format-Table -AutoSize
    $processMemoryUsage | Format-Table | Out-String|% {Write-Host $_}
}


[String[]]$CompNames = "sm-navsrv001", "sm-navsrv002", "sm-navsrv003", "SM-ap003", "SM-AP004", "SM-DC003", "SM-DC005"
foreach($CompName in $CompNames) {
    # Get Computer Object
    write-host "`n" $CompName.ToUpper() -BackgroundColor Green -ForegroundColor Black

    Get-WmiObject Win32_OperatingSystem -ComputerName $CompName | Select PSComputerName, Caption, OSArchitecture, Version, BuildNumber | FL
    # Top 5 process Memory Usage (MB)
    $processMemoryUsage = Get-WmiObject WIN32_PROCESS -ComputerName $CompName  | Sort-Object -Property ws -Descending | Select-Object -first 5 processname, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}| Format-Table -AutoSize
    $processMemoryUsage | Format-Table | Out-String|% {Write-Host $_}

    GetTotalPhysicalOnRemote($CompName)


    $CompObject =  Get-WmiObject -Class WIN32_OperatingSystem -ComputerName $CompName  
    $Memory = [Decimal]((($CompObject.TotalVisibleMemorySize - $CompObject.FreePhysicalMemory)*100)/ $CompObject.TotalVisibleMemorySize)
    $Memory = [Math]::Round($Memory,2)
    Write-Host "Memory usage: " -nonewline
    if ($Memory -gt 80) {
       Write-Host $Memory "%" -ForegroundColor White -BackgroundColor Red
    } else {
       Write-Host $Memory "%" -ForegroundColor Green
    }
    
    $ProcessorUsage = (Get-WmiObject -ComputerName 'sm-navsrv003' -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average
    Write-Host "Processor usage: " -nonewline
    if ($ProcessorUsage -gt 80) {
        Write-Host  $ProcessorUsage "%" -ForegroundColor White -BackgroundColor Red
     } else {
        Write-Host $ProcessorUsage "%" -ForegroundColor Green
     }

    $DiskUsage = Get-WmiObject Win32_LogicalDisk -ComputerName  $CompName -Filter DriveType=3 | Select-Object DeviceID, FreeSpace, Size 
    foreach($Disk in $DiskUsage) {
        $FreeDiskInGB = $Disk.FreeSpace/1GB
        $FreeDiskInGB = [Math]::Round($FreeDiskInGB,2)
        Write-host "Free disk " $Disk.DeviceID " " -nonewline
        Write-Host $FreeDiskInGB "GB"
    }
}

Write-Host "`n`n`n"
