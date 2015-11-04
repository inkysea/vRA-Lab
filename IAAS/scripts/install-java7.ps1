if (!(test-path -Path "c:\Temp")){
					Write-Host "Creating folder C:\Temp" -ForegroundColor Green
					New-Item -ItemType Directory -Force -Path "C:\Temp"
}

Write-Host "Preparing to Download Java JRE 1.7" -ForegroundColor Green
Write-Host "Attempting to Download Java. Please be patient." -ForegroundColor Green
$downloadjava = New-Object Net.WebClient
$javaurl = "http://javadl.sun.com/webapps/download/AutoDL?BundleId=95125"
$javafile = ("C:\Temp\javajre17.exe")
$downloadjava.Downloadfile($javaurl,$javafile)

if (!(Test-Path -Path "C:\Temp\javajre17.exe")) {Write-Host "Uh Oh. For some reason we were unable to download the Java installer correctly" -ForegroundColor Yellow
	Throw "Please check your internet connection and rerun this script" } else {Write-Host "File downloaded successfully... Proceeding" -ForegroundColor Green}

Write-Host "Attempting to Install Java. Please be patient." -ForegroundColor Green
Write-Verbose ""
$InstallJava = Start-Process $javafile -ArgumentList "/s" -Wait -PassThru
Write-Host "Java installation finished. Proceeding with script." -ForegroundColor Green

Write-Host "Setting Java_HOME variable to C:\Program Files\Java\jre7" -ForegroundColor Green
setx /M JAVA_HOME "C:\Program Files\Java\jre7"
Write-Host "Java_HOME variable set." -ForegroundColor Green