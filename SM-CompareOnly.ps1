$ObjectFilter = $args[0]
$NewObjectFilter = ''

if ($ObjectFilter.Substring(0,1) -eq 'c')
{
    $NewObjectFilter = "Type=Codeunit;ID=" + $ObjectFilter.Substring(1)
}
if ($ObjectFilter.Substring(0,1) -eq 't')
{
    $NewObjectFilter = "Type=Table;ID=" + $ObjectFilter.Substring(1)
}
if ($ObjectFilter.Substring(0,1) -contains 'p')
{
    $NewObjectFilter = "Type=Page;ID=" + $ObjectFilter.Substring(1)
}
if ($ObjectFilter.Substring(0,1) -contains 'r')
{
    $NewObjectFilter = "Type=Report;ID=" + $ObjectFilter.Substring(1)
}
if ($ObjectFilter.Substring(0,1) -contains 'x')
{
    $NewObjectFilter = "Type=XMLPort;ID=" + $ObjectFilter.Substring(1)
}

#$pathToSaveFobProd = "\\sm-ap003\it\Förvaltning\NAV\objekt\mindre_uppdateringar\fob\" + $ObjectFilter + "__" + $(get-date -Format "yyMMdd_HHmm") + ".fob"#//-f yyyy-MM-dd) 
#$pathToSaveTxtProd = "\\sm-ap003\it\Förvaltning\NAV\objekt\mindre_uppdateringar\" + $ObjectFilter + "__" + $(get-date -Format "yyMMdd_HHmm") + "_prod.txt"#//-f yyyy-MM-dd) 
#$pathToSaveTxtDev = "\\sm-ap003\it\Förvaltning\NAV\objekt\mindre_uppdateringar\" + $ObjectFilter + "__" + $(get-date -Format "yyMMdd_HHmm") + "_dev.txt"#//-f yyyy-MM-dd) 

#Write-Output $ObjectFilter
#Write-Output $NewObjectFilter

Export-NAVApplicationObject -DatabaseName nav_dev -DatabaseServer "sm-sql003" -Path "C:\Users\andcar\Documents\ny.txt" -Filter $NewObjectFilter -Force
Export-NAVApplicationObject -DatabaseName nav_prod -DatabaseServer "sm-sql003" -Path "C:\Users\andcar\Documents\gammal.txt" -Filter $NewObjectFilter -Force
#Export-NAVApplicationObject -DatabaseName nav_dev -DatabaseServer "sm-sql003" -Path "C:\Users\andcar\Documents\xx.fob" -Filter $NewObjectFilter -Force
#Export-NAVApplicationObject -DatabaseName nav_prod -DatabaseServer "sm-sql003" -Path $pathToSaveFobProd -Filter $NewObjectFilter -Force
#Export-NAVApplicationObject -DatabaseName nav_prod -DatabaseServer "sm-sql003" -Path $pathToSaveTxtProd -Filter $NewObjectFilter -Force
#Export-NAVApplicationObject -DatabaseName nav_dev -DatabaseServer "sm-sql003" -Path $pathToSaveTxtDev -Filter $NewObjectFilter -Force

