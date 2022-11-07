# From cmd
# runas /user:swedemount\administrator powershell.exe

[String[]]$CompNames = "sm-navsrv001", "sm-navsrv002", "sm-navsrv003", "SM-ap003", "SM-AP004", "SM-DC003", "SM-DC005"
foreach($CompName in $CompNames) {
 # Get Computer Object
    write-host $CompName.ToUpper() -BackgroundColor Green -ForegroundColor Black

    $ProcessorLoad = Get-WmiObject Win32_Processor -ComputerName $CompName | Measure-Object -Property LoadPercentage -Average | Select Average
    Write-Host "Processor usage: " $ProcessorLoad
    
    $TotslPhysicalMemory = Get-WMIObject -Computername $CompName -class win32_ComputerSystem| Select-Object -Expand TotalPhysicalMemory
    $TotslPhysicalMemory = [Math]::Round($TotslPhysicalMemory / 1GB,2)
    Write-Host "Total physical memory (GB) " $TotslPhysicalMemory
    
    $CompObject =  Get-WmiObject -Class WIN32_OperatingSystem -ComputerName $CompName  
    $Memory = [Decimal]((($CompObject.TotalVisibleMemorySize - $CompObject.FreePhysicalMemory)*100)/ $CompObject.TotalVisibleMemorySize)
    $Memory = [Math]::Round($Memory,2)
    Write-Host "Memory usage in Percentage: " -nonewline
    if ($Memory -gt 80) {
       Write-Host  $Memory -ForegroundColor White -BackgroundColor Red
    } else {
       Write-Host $Memory  -ForegroundColor Green
    }

    # Top 5 process Memory Usage (MB)
    $processMemoryUsage = Get-WmiObject WIN32_PROCESS -ComputerName $CompName  | Sort-Object -Property ws -Descending | Select-Object -first 5 processname, @{Name="Mem Usage(MB)";Expression={[math]::round($_.ws / 1mb)}}| Format-Table -AutoSize
    $processMemoryUsage | Format-Table | Out-String|% {Write-Host $_}
}
