

$url=$args[0]

if (!$url){

$download_url=$Env:vmware_tools_url

}else{
$download_url = $url

}


$download_url=$ENV:VRA_AGENT_URL


write-host "Dowloading from : $download_url" -ForegroundColor Yellow;

$download = New-Object Net.WebClient


$file = ("C:\Windows\Temp\vCAC-IaaSManagementAgent-Setup.msi")

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$download.Downloadfile($download_url, $file)

write-host "Download Complete : $file" -ForegroundColor Yellow;

write-host "Installing : $file" -ForegroundColor Yellow;

& msiexec /i $file /qb `
    MANAGEMENT_ENDPOINT_ADDRESS="https://vra-app-1.inkysea.com:5480/" `
    MANAGEMENT_ENDPOINT_THUMBPRINT=C144BD5F039FF26A850DF9774BC3508E650729A0 `
    LicenseAccepted=1  `
    SERVICE_USER_NAME=VAGRANT-2012R2\\iaassvc `
    SERVICE_USER_PASSWORD=VMware1! `
    VA_USER_NAME=root `
    VA_USER_PASSWORD=VMware123! `
    EndpointThumbprintAccepted=1 `
    EndpointThumbprintAcceptedTwin=1 `
    CURRENT_MACHINE_FQDN=VRA-IAAS-2.inkysea.local `
    | Out-Null


write-host "Install Complete : $file" -ForegroundColor Yellow;


