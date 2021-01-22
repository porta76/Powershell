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
