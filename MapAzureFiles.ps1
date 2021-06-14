# VPN Must be availible

$connectTestResult = Test-NetConnection -ComputerName swarmvfuebbuvstorage.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"swarmvfuebbuvstorage.file.core.windows.net`" /user:`"Azure\swarmvfuebbuvstorage`" /pass:`"/I1cQiPPqf81OTbzZnEVqDIjPcU0h3aNdp2gCnsjB6PHGSRca3Ri/37+a4QBwBIb8TB2O4iuwPtd562bQdTugg==`""
    # Mount the drive
    New-PSDrive -Name Z -PSProvider FileSystem -Root "\\swarmvfuebbuvstorage.file.core.windows.net\share" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}
