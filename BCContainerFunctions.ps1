# To get older versions and other images
# Run scripts go get proper artifact Urls
#
#   Write-Host -ForegroundColor Yellow "Get all NAV 2018 SE artifact Urls"
#   (Get-NavArtifactUrl -nav 2018 -country 'se' -select all).count
#   Get-NavArtifactUrl -nav 2018 -country 'se' -select all

# Get the BC Containerhelper
# See also: https://freddysblog.com/2020/08/11/bccontainerhelper/
Uninstall-Module navcontainerhelper -AllVersions
Install-Module BcContainerHelper -force

# Creates a BC Container
$artifactUrl = Get-BCArtifactUrl -version 17 -country se -select Latest
$credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'P@ssword1' -AsPlainText -Force)

# Install testlibraries for automated testing
# Test libraries requires a developer license
New-BcContainer `
    -accept_eula `
    -containerName devBC `
    -artifactUrl $artifactUrl `
    -Credential $credential `
    -auth UserPassword `
    -dns '8.8.8.8' `
    -memoryLimit 5G `
    -includeTestToolkit -includeTestLibrariesOnly `
    -updateHosts `
    -licenseFile 'License.flf'
    
    
# Example regarding information about images    
# Ex 1   
Write-Host -ForegroundColor Yellow "Get all BC 15 SE artifact Urls"
(Get-BCArtifactUrl -version 15 -select all).count
Get-BCArtifactUrl -version 15  -select all

# Ex2
Write-Host -ForegroundColor Yellow "Get all BC SE artifact Urls OnPrem"
Get-BCArtifactUrl -country "se" -type OnPrem -select all

# Ex 3
Write-Host -ForegroundColor Yellow "Get all NAV 2018 SE artifact Urls"
(Get-NavArtifactUrl -nav 2018 -country 'se' -select all).count
Get-NavArtifactUrl -nav 2018 -country 'se' -select all
