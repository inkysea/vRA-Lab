$url=$args[0]

if (!$url){

$download_url=$ENV:sql_url

}else{
$download_url = $ENV:SQL_URL

}

$download_url=$ENV:SQL_URL


write-host "SQL Express 2012 R2 not Found, Downloading..." -ForegroundColor Yellow;
write-host "Dowloading from : $download_url" -ForegroundColor Yellow;

$download = New-Object Net.WebClient

$file = ("C:\Windows\Temp\SQLSetup.exe")
$download.Downloadfile($download_url, $file)

if (!(Test-Path -Path $file )) { Throw "Error: Unable to download the SQL Express Installer correctly" }


write-host "Scheduleing install : $file" -ForegroundColor Yellow;


$Sta = New-ScheduledTaskAction -Execute $file -argument "/Q /configurationfile=c:/Windows/Temp/SQLConfiguration.ini"
$ts = New-TimeSpan -Minutes 1
$sched = (get-date) + $ts
$hour = $sched.Hour
$minute = $sched.minute+1
$final_schedule = "$hour"+":"+"$minute"


$Stt = New-ScheduledTaskTrigger -Once -At $final_schedule

Register-ScheduledTask SQLInstall -Action $Sta -Trigger $Stt

write-host "Install Scheduled: $file" -ForegroundColor Yellow;


$sqlInstances = gwmi win32_service -computerName localhost | ? { $_.Name -match "mssql*" -and $_.PathName -match "sqlservr.exe" } | % { $_.Caption }
$res = $sqlInstances -ne $null -and $sqlInstances -gt 0

while($res -ne "True"){

Start-Sleep -s 10

$sqlInstances = gwmi win32_service -computerName localhost | ? { $_.Name -match "mssql*" -and $_.PathName -match "sqlservr.exe" } | % { $_.Caption }
$res = $sqlInstances -ne $null -and $sqlInstances -gt 0
  if ($res) {
        Write-host "SQL Server is installed"
  } else {
        Write-host "SQL Server is not yet installed"
  }
}

# Configure TCP port to 1433

$SQLName = $env:computername
$Instance = 'SQLEXPRESS'

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement") | out-null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Management") | out-null


$m = New-Object ('Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer') $SQLName

$urn = "ManagedComputer[@Name='$SQLName']/ServerInstance[@Name='$Instance']/ServerProtocol[@Name='Tcp']"
$Tcp = $m.GetSmoObject($urn)

$m.GetSmoObject($urn + "/IPAddress[@Name='IPAll']").IPAddressProperties['TcpPort'].Value = "1433"
$m.GetSmoObject($urn + "/IPAddress[@Name='IPAll']").IPAddressProperties['TcpDynamicPorts'].Value = ""

$TCP.alter()

exit 0