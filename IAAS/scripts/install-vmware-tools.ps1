$version = '9.6.1'

$url=$args[0]

if (!$url){

$download_url=$Env:vmware_tools_url

}else{
$download_url = $url

}

write-host "Dowloading from : $download_url" -ForegroundColor Yellow;

$download = New-Object Net.WebClient


$file = ("C:\Windows\Temp\VMware-tools-setup.exe")

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$download.Downloadfile($download_url, $file)

write-host "Download Complete : $file" -ForegroundColor Yellow;

$date_out = Get-Date

write-host "$date_out Install Tools  : $file" -ForegroundColor Yellow;

#$args = "/S /v "/qn REBOOT=R"

&$file /S /v "/qn REBOOT=R" | Out-Host

#Start-Process C:\Windows\Temp\VMware-tools-setup.exe -ArgumentList /S,/v,"/qn REBOOT=R" -Wait

$date_out = Get-Date

write-host "$date_out Install Tools complete : $file" -ForegroundColor Yellow;

Start-Sleep -s 30

exit 0