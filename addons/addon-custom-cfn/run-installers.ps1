#create script to download installers
$downloadInstallers = @'
$uri = [System.Uri]"${EnvironmentInstanceFiles}"
$key = "$($uri.AbsolutePath.Substring(1))/bin/QualysCloudAgent.exe"
Read-S3Object -BucketName $uri.Host -Key $key -File QualysCloudAgent.exe
$key = "$($uri.AbsolutePath.Substring(1))/bin/R.exe"
Read-S3Object -BucketName $uri.Host -Key $key -File R.exe
$key = "$($uri.AbsolutePath.Substring(1))/bin/RStudio.exe"
Read-S3Object -BucketName $uri.Host -Key $key -File RStudio.exe
$key = "$($uri.AbsolutePath.Substring(1))/bin/rtools.exe"
Read-S3Object -BucketName $uri.Host -Key $key -File rtools.exe
$key = "$($uri.AbsolutePath.Substring(1))/bin/snowflake-jdbc.jar"
Read-S3Object -BucketName $uri.Host -Key $key -File snowflake-jdbc.jar
$key = "$($uri.AbsolutePath.Substring(1))/bin/snowflake64_odbc.msi"
Read-S3Object -BucketName $uri.Host -Key $key -File snowflake64_odbc.msi
$key = "$($uri.AbsolutePath.Substring(1))/bin/jre.exe"
Read-S3Object -BucketName $uri.Host -Key $key -File jre.exe
$key = "$($uri.AbsolutePath.Substring(1))/bin/GitHubDesktopSetup-x64.exe"
Read-S3Object -BucketName $uri.Host -Key $key -File GitHubDesktopSetup-x64.exe
$key = "$($uri.AbsolutePath.Substring(1))/bin/run-installers.ps1"
Read-S3Object -BucketName $uri.Host -Key $key -File run-installers.ps1
$key = "$($uri.AbsolutePath.Substring(1))/bin/ChromeSetup.exe"
Read-S3Object -BucketName $uri.Host -Key $key -File ChromeSetup.exe
$key = "$($uri.AbsolutePath.Substring(1))/bin/FirefoxSetup.exe"
Read-S3Object -BucketName $uri.Host -Key $key -File FirefoxSetup.exe

'@
Set-Content -Path C:\workdir\InstallerDownload.ps1 -Value $downloadInstallers

#run the script just created, downloads all installers from s3 bucket
."C:\workdir\InstallerDownload.ps1"


#run all installers
cmd /c  "c:\workdir\GitHubDesktopSetup-x64.exe /s"
c:\workdir\R.exe /verysilent
c:\workdir\RStudio.exe /S
c:\workdir\rtools.exe /verysilent
c:\workdir\snowflake64_odbc.msi /quiet
cmd /c "c:\workdir\QualysCloudAgent.exe CustomerId={b288187c-6e29-d330-8389-5b291af9e73f} ActivationId={75beca74-1e31-49b0-a353-cb176a99d0ef} WebServiceUri=https://qagpublic.qg1.apps.qualys.com/CloudAgent/"
c:\workdir\jre.exe /s
c:\workdir\FirefoxSetup.exe /S
cmd /c "c:\workdir\ChromeSetup.exe /silent /install"

#create shortcut to rstudio on desktop
New-Item -ItemType SymbolicLink -Path C:\Users\Administrator\Desktop\ -Name "RStudio.lnk" -Value "C:\Program Files\RStudio\bin\rstudio.exe"

#rename guest account per qualys report
Rename-LocalUser -name Guest -newname NotGuest