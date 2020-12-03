#Upgrade BC15 to BC16
#Lägg upp en tjänst för BC160
#Starta 2 NavAdminTools för BC150 och en för BC160
import-module "C:\Program Files\Microsoft Dynamics 365 Business Central\160\Service\NavAdminTool.ps1"
$instance = 'BC160'
$version = '16.0.11240.12076'
$systempath = 'C:\Program Files (x86)\Microsoft Dynamics 365 Business Central\160\AL Development Environment\system.app'
$mssystempath = 'C:\Users\icsebsid\Downloads\Dynamics.365.BC.12076.SE.DVD\Applications\system application\source\Microsoft_System Application.app'
$baseapppath = 'C:\Users\icsebsid\Downloads\Dynamics.365.BC.12076.SE.DVD\Applications\BaseApp\Source\Microsoft_Base Application.app'
$application = 'C:\Users\icsebsid\Downloads\Dynamics.365.BC.12076.SE.DVD\Applications\Application\Source\Microsoft_Application.app'
$license = "C:\Cosmo\Licenser\SWEDEN Developer License Business Central_16.flf"
$oldversion = '15.2.39040.0'
#Detta steg görs först i gamla versionen mot den gamla serverinstansen (BC150)
Get-NAVAppInfo -ServerInstance $instance | % { Uninstall-NAVApp -ServerInstance $instance -Name $_.Name -Version $_.Version -Force}
#Nedanstående steg görs mot den nya serverinstansen (BC160)
Invoke-NAVApplicationDatabaseConversion -DatabaseName nordic_bc_test -DatabaseServer IC-SQL01
Import-NAVServerLicense -LicenseFile $license -ServerInstance BC160
#Set-NAVServerConfiguration -ServerInstance $instance -KeyName DatabaseName -KeyValue nordic_bc_150_cronus
#Set-NavServerConfiguration -ServerInstance $instance -KeyName "EnableTaskScheduler" -KeyValue false
Restart-NAVServerInstance -ServerInstance $instance
Unpublish-NAVApp -ServerInstance $instance -name System -version $oldversion
Publish-NAVApp -ServerInstance $instance -path $systempath -PackageType SymbolsOnly
Publish-NAVApp -ServerInstance $instance -Path $mssystempath
Sync-NAVTenant -ServerInstance $instance -mode Sync
Get-NAVAppInfo -ServerInstance $instance 
#kolla versionen på den nya System Application
Sync-NAVApp -ServerInstance $instance -Name "System Application" -Version $version
Start-NAVAppDataUpgrade -ServerInstance $instance -Name "System Application" -version $version
Publish-NAVApp -ServerInstance $instance -path $baseapppath
Sync-NAVApp -ServerInstance $instance -Name "Base Application" -Version $version
Start-NAVAppDataUpgrade -ServerInstance $instance -Name "Base Application" -version $version
Publish-NAVApp -ServerInstance $instance -path $application
Sync-NAVApp -ServerInstance $instance -Name Application -version $version
Install-NAVApp -ServerInstance $instance -Name Application -Version $version
Set-NAVApplication -ServerInstance $instance -ApplicationVersion $version -Force
Sync-NAVTenant -ServerInstance $instance -mode Sync
#Övriga extensions
Publish-NAVApp -ServerInstance $instance -path "C:\Users\icsebsid\Downloads\swebase\SmartApps_LicenseProvider_OnPrem_16.0.4007.100.app"
Sync-NAVApp -ServerInstance $instance -Name LicenseProvider -Version 16.0.4007.100
Start-NAVAppDataUpgrade -ServerInstance $instance -Name LicenseProvider -Version 16.0.4007.100
Publish-NAVApp -ServerInstance $instance -path "C:\Users\icsebsid\Downloads\swebase\SmartApps_SweBase_16.0.4103.0_RP.app"
Sync-NAVApp -ServerInstance $instance -Name SweBase -Version 16.0.4103.0 
Start-NAVAppDataUpgrade -ServerInstance $instance -Name SweBase -Version 16.0.4103.0
Publish-NAVApp -ServerInstance $instance -path "C:\Users\icsebsid\Downloads\Cosmo Consult SE_CCSE-CUSTOMER-NORDIC-EXT_2.5.0.0.app" -SkipVerification
Sync-NAVApp -ServerInstance $instance -Name CCSE-CUSTOMER-NORDIC-EXT -Version 2.5.0.0
Sync-NAVTenant -ServerInstance $instance -mode Sync
Get-NAVAppInfo -ServerInstance $instance | % { Unpublish-NAVApp -ServerInstance $instance -Name $_.Name -Version $oldversion}
Install-NAVApp -ServerInstance $instance -Name LicenseProvider -Version 16.0.4007.100
Install-NAVApp -ServerInstance $instance -Name Swebase -Version 16.0.4103.0
 
