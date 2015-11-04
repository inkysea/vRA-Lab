$cn = [ADSI]"WinNT://$Env:COMPUTERNAME"

$username = "iaassvc"
$password = "VMware1!"

$user = $cn.Create("User",$username)
$user.SetPassword($password)
$user.setInfo()
$user.description = "IAAS service account user"
$user.SetInfo()
$group = [ADSI]("WinNT://$Env:COMPUTERNAME/administrators,group")
$group.add("WinNT://$username,user")

exit 0