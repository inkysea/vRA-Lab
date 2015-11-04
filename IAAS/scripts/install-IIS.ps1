#import-module ServerManager
#Add-WindowsFeature Web-Server
#Set IIS default locations to be used with IIS role
$InetPubRoot = "C:\Inetpub"
$InetPubLog = "C:\Inetpub\Log"
$InetPubWWWRoot = "C:\Inetpub\WWWRoot"


$InstallSource="D:\sources\sxs"

Write-Host "Attempting to Install .NET Framework. Please be patient." -ForegroundColor Green
Add-WindowsFeature -Name Web-Webserver,Web-Http-Redirect,Web-Asp-Net,Web-Windows-Auth,Web-Mgmt-Console,Web-Mgmt-Compat, web-metabase -Source $InstallSource

Write-Host "Adding Windows features " -ForegroundColor Yellow
Install-WindowsFeature -name NET-Framework-Core,net-wcf-http-activation45
Add-windowsfeature -name was, was-config-apis, was-Net-Environment,NET-Non-HTTP-Activ -Source $InstallSource
Write-Host "Features installation complete, loading IIS module "  -ForegroundColor Green



Import-Module WebAdministration

# Build the IIS folder structure
Write-Host "Setting up folder structure"  -ForegroundColor Yellow
New-Item -Path $InetPubRoot -type directory -Force -ErrorAction SilentlyContinue
New-Item -Path $InetPubLog -type directory -Force -ErrorAction SilentlyContinue
New-Item -Path $InetPubWWWRoot -type directory -Force -ErrorAction SilentlyContinue

# Set the directory access for 'Builtin\IIS_IUSRS' and 'NT SERVICE\TrustedInstaller'
$Command = "icacls $InetPubWWWRoot /grant BUILTIN\IIS_IUSRS:(OI)(CI)(RX) BUILTIN\Users:(OI)(CI)(RX)"
cmd.exe /c $Command
$Command = "icacls $InetPubLog /grant ""NT SERVICE\TrustedInstaller"":(OI)(CI)(F)"
cmd.exe /c $Command

# Setting the default website location used in vCAC
Set-ItemProperty 'IIS:\Sites\Default Web Site' -name physicalPath -value $InetPubWWWRoot

# Setting authentication values for IIS
# Anonymous Authentication needs to be disabled
# Windows Authentication needs to be enabled
Write-Host "Setting authentication values for IIS" -ForegroundColor Yellow
Set-WebConfigurationProperty -Location 'Default Web Site' -Filter /system.webServer/security/authentication/AnonymousAuthentication  -Name Enabled -Value $true
Set-WebConfigurationProperty -Location 'Default Web Site' -Filter /system.webServer/security/authentication/AnonymousAuthentication  -Name Enabled -Value $false

Set-WebConfigurationProperty -Location 'Default Web Site' -Filter /system.webServer/security/authentication/windowsAuthentication  -Name Enabled -Value $false
Set-WebConfigurationProperty -Location 'Default Web Site' -Filter /system.webServer/security/authentication/windowsAuthentication  -Name Enabled -Value $true

# Sometimes the pre-req checker cannot distinguish the values of the Windows authentication without
# The providers being removed and added back in.
# Removing and re-adding Windows authentication providers

Write-Host "Removing & Re-Adding Windows authentication providers" -ForegroundColor Yellow
# Authentication Providers code by Jonathan Medd http://www.jonathanmedd.net
Get-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication -Location 'Default Web Site' -Name providers.Collection | Select-Object -ExpandProperty Value | ForEach-Object {Remove-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication -Location 'Default Web Site' -Name providers.Collection -AtElement @{value=$_}}
Add-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication -Location 'Default Web Site' -Name providers.Collection -AtIndex 0 -Value "Negotiate"
Add-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication -Location 'Default Web Site' -Name providers.Collection -AtIndex 1 -Value "NTLM"

# Extended protection needs to be enabled and disabled for vCAC to recognize the value
# Enable and disable the Extended Protection
Write-Host "Enabling and disabling Extended Protection" -ForegroundColor Yellow
Set-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication -Location 'Default Web Site' -Name extendedProtection.tokenChecking -Value 'Allow'
Set-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication -Location 'Default Web Site' -Name extendedProtection.tokenChecking -Value 'None'

# The same must happen with Kernel-Mode. This will disable then re-enable the value
# Resetting KERNEL MODE
Write-Host "Resetting Kernel Mode" -ForegroundColor Yellow
Set-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication -Location 'Default Web Site' -Name useKernelMode -Value $false
Set-WebConfigurationProperty -Filter system.webServer/security/authentication/WindowsAuthentication -Location 'Default Web Site' -Name useKernelMode -Value $true

# IIS must be restarted for the changes to take effect
# Resetting IIS
Write-Host "Resetting IIS" -ForegroundColor Yellow
$Command = "IISRESET"
Invoke-Expression -Command $Command
Write-Host "IIS Reset Complete..."  -ForegroundColor Green


