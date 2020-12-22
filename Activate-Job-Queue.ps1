## Using BC as serverinstance (Cosmo backend default)
Set-NavServerConfiguration -ServerInstance BC -KeyName EnableTaskScheduler -KeyValue true
Set-NavServerInstance -ServerInstance BC -restart
