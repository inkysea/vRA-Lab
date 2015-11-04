# MSDTC is used for Coordinating Transactions spanning several resource managers (databases, message queues, etc)
# The following settings will allow vCAC to function properly on the network.
# Setting the MSDTC components
Write-Host "Setting MSDTC components in the registry. Please restart your system after installation completes" -ForegroundColor Yellow
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name LuTransactions -Value 1
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccess -Value 1
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessInbound -Value 1
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessOutbound -Value 1
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcClients -Value 1
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessTransactions -Value 1
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessAdmin -Value 1
Set-ItemProperty -Path HKLM:\Software\Microsoft\MSDTC\Security -Name NetworkDtcAccessClients -Value 1

# The Distributed Transaction Coordinator needs to have access through the firewall
# The following line of code is all that we will use. (If the firewall is enabled it
# Will utilize the rule, if the firewall is disabled, this can be ignored
# Creating firewall rule for DTC

#netsh advfirewall firewall set rule group="Distributed Transaction Coordinator" new enable=Yes | Out-Null
netsh advfirewall firewall set rule group="Distributed Transaction Coordinator" new enable=Yes


# Automatic and start the service
Write-Host "Enabling Secondary Logon Service" -ForegroundColor Yellow

	if ((Get-Service seclogon).Status -ne 'Running'){
		Set-Service Seclogon -StartupType Automatic
    	Start-Service seclogon
		Write-Host "Secondary Logon Service Enabled..."  -ForegroundColor Yellow
	}

New-ItemProperty HKLM:\System\CurrentControlSet\Control\Lsa -Name "DisableLoopbackCheck" -Value "1" -PropertyType dword
