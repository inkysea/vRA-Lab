

$service = Get-Service -Name ADWS
$service.WaitForStatus('Running','00:10:00')

while ($service.Status -ne 'Running'){
	Write-Warning 'Service not started. Exiting with 1'
	exit 1
}

# Sleep work around as I couldn't figure out which service was preventing dsadd from running properly
Start-Sleep -s 60


# Place groups and users to populate AD here
# used dsadd due to winrm CredSSP  challenges

& dsadd group "cn=vRA Admins,cn=Users,dc=corp,dc=local"

& dsadd user "cn=Cloud Admin,cn=Users,dc=corp,dc=local" `
  	-samid cloudadmin `
  	-upn cloudadmin@corp.local `
  	-fn "Cloud" -ln "Admin" -display "Cloud Admin" `
  	-email cloudadmin@corp.local `
  	-pwdneverexpires yes -mustchpwd no -disabled no -pwd VMWare1! `
      -memberof "cn=vRA Admins,cn=Users,dc=corp,dc=local" `
                "CN=Domain Admins,CN=Users,DC=corp,DC=local" `
      -acctexpires never




exit 0
