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
$sched = Get-Date
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
        Write-host "SQL Server is not installed"
  }
}



exit 0