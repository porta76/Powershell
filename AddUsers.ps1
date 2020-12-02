# Adds an user from powershell
# Nice to have when you cant connect to BC

$nav = 'My Server Instance eg: BC170'
New-NAVServerUser -WindowsAccount YourDomain\cosmo -ServerInstance $nav -Fullname "Name of user goes here"
New-NAVServerUserPermissionSet $nav -WindowsAccount YourDomain\cosmo -PermissionSetId SUPER

