// Start to publish navapp
Publish-NAVApp -ServerInstance BC -Path '.\System.app' -PackageType SymbolsOnly

// Syncronize app
Sync-NAVApp -ServerInstance BC -Name 'Proseware SmartApp'

// Install navapp
Install-NAVApp -ServerInstance BC -Name 'Proseware SmartApp' -Version 2.3.4.500

