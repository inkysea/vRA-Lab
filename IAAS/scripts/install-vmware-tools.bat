


SET file=C:\Windows\Temp\VMware-tools-setup.exe

powershell -Command "Invoke-WebRequest %VMWARE_TOOLS_URL% -OutFile %file%"


cmd /c C:\Windows\Temp\VMware-tools-setup.exe /S /v"/qn REBOOT=R\"


EXIT /B 0
