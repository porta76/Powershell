# Creates a BC Container
$artifactUrl = Get-BCArtifactUrl -version 17 -country se -select Latest
$credential = New-Object pscredential 'admin', (ConvertTo-SecureString -String 'P@ssword1' -AsPlainText -Force)

New-BcContainer `
    -accept_eula `
    -containerName test `
    -artifactUrl $artifactUrl `
    -Credential $credential `
    -auth UserPassword `
    -updateHosts