#run all installers
Start-Process "c:\workdir\snowflake64_odbc.msi" -argumentlist  "/quiet" -wait
Start-Process "c:\workdir\GitHubDesktopSetup-x64.exe" -argumentlist  "/s" -wait
Start-Process "c:\workdir\R.exe" -argumentlist  "/verysilent" -wait
Start-Process "c:\workdir\RStudio.exe" -argumentlist  "/S" -wait
Start-Process "c:\workdir\rtools.exe" -argumentlist  "/verysilent" -wait
Start-Process "c:\workdir\python-3.10.exe" -argumentlist  "/quiet PrependPath=1" -wait
Start-Process "c:\workdir\QualysCloudAgent.exe" -argumentlist  "CustomerId={b288187c-6e29-d330-8389-5b291af9e73f} ActivationId={75beca74-1e31-49b0-a353-cb176a99d0ef} WebServiceUri=https://qagpublic.qg1.apps.qualys.com/CloudAgent/" -wait
Start-Process "c:\workdir\jre.exe" -argumentlist  "/s" -wait
Start-Process "c:\workdir\FirefoxSetup.exe" -argumentlist  "/S" -wait
Start-Process "c:\workdir\ChromeSetup.exe" -argumentlist  "/silent /install" -wait
Start-Process "c:\workdir\PortableGit.7z.exe" -argumentlist  "-o c:\git -y" -wait
Start-Process "c:\workdir\AWSCLIV2.msi" -argumentlist  "/quiet" -wait

#create shortcut to rstudio on desktop
New-Item -ItemType SymbolicLink -Path C:\Users\Administrator\Desktop\ -Name "RStudio.lnk" -Value "C:\Program Files\RStudio\bin\rstudio.exe"

#rename guest account per qualys report
Rename-LocalUser -name Guest -newname NotGuest

#remove ec2 guide/feedback shortcuts
rm 'C:\Users\Administrator\Desktop\EC2 Feedback.website'
rm 'C:\Users\Administrator\Desktop\EC2 Microsoft Windows Guide.website'

#add git to path
setx path "%path%;C:\git\bin;c:\Program Files\Amazon\AWSCLIV2"