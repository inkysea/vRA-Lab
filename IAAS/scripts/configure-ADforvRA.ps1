New-ADUser -Name "Cloud Admin" -GivenName cloud -Surname admin `
    -SamAccountName cloudadmin -UserPrincipalName cloudadmin@corp.local `
    -AccountPassword (Read-Host -AsSecureString "VMware1!") `
    -PassThru | Enable-ADAccount

NEW-ADGroup –name “vRAadmins” –groupscope Global

Add-ADGroupMember "Domain Admins" cloudadmin;
Add-ADGroupMember "vRAAdmins" cloudadmin;