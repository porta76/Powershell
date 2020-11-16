function fact-ListProfileLocations()
{
    foreach ($profileLocation in ($PROFILE | Get-Member -MemberType NoteProperty).Name)
    {
        Write-Host "$($profileLocation): $($PROFILE.$profileLocation)"
    }
}

function fact()
{
    Param(
	[Parameter(Mandatory=$False)]
	[string]$Text = 'fact', 
        [Parameter(Mandatory=$False)]
        [int]$Limit = 20
    )
    $searchHistString ="*" +$Text+ "*";
    cat(Get-PSReadlineOption).HistorySavePath | ? {$_ -like $searchHistString } | Select-Object -Last $Limit
}