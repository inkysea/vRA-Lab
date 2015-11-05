
dsadd group "cn=vRA Admins,cn=Users,dc=corp,dc=local"


dsadd user "cn=Cloud Admin,cn=Users,dc=corp,dc=local" ^
	-samid cloudadmin ^
	-upn cloudadmin@corp.local ^
	-fn "Cloud" -ln "Admin" -display "Cloud Admin" ^
	-email cloudadmin@corp.local ^
	-pwdneverexpires yes -mustchpwd no -disabled no -pwd VMWare1! ^
    -memberof "cn=vRA Admins,cn=Users,dc=corp,dc=local" ^
              "CN=Domain Admins,CN=Users,DC=corp,DC=local" ^
    -acctexpires never



choice /T 300 /d y > NUL

Exit /B 0
