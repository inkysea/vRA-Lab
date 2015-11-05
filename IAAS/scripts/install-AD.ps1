
Get-WindowsFeature AD-Domain-Services | Install-WindowsFeature -IncludeManagementTools

Import-Module ADDSDeployment

$AdminPassword = "VMware1!"

Install-ADDSForest -CreateDnsDelegation:$False `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Win2012R2" `
    -DomainName "corp.local" `
    -DomainNetbiosName "corp" `
    -ForestMode "Win2012R2" `
    -InstallDns:$True `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$True `
    -SafeModeAdministratorPassword ($AdminPassword | ConvertTo-SecureString -AsPlainText -Force) `
    -SkipPreChecks