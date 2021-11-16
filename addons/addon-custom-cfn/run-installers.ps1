#run all installers
cmd /c  "c:\workdir\GitHubDesktopSetup-x64.exe /s"
c:\workdir\R.exe /verysilent
c:\workdir\RStudio.exe /S
c:\workdir\rtools.exe /verysilent
c:\workdir\snowflake64_odbc.msi /quiet
c:\workdir\AWSCLIV2.msi /quiet
c:\workdir\python-3.10.exe /quiet PrependPath=1
cmd /c "c:\workdir\QualysCloudAgent.exe CustomerId={b288187c-6e29-d330-8389-5b291af9e73f} ActivationId={75beca74-1e31-49b0-a353-cb176a99d0ef} WebServiceUri=https://qagpublic.qg1.apps.qualys.com/CloudAgent/"
c:\workdir\jre.exe /s
c:\workdir\FirefoxSetup.exe /S
cmd /c "c:\workdir\ChromeSetup.exe /silent /install"
c:\workdir\PortableGit.7z.exe -o c:\git -y

#create shortcut to rstudio on desktop
New-Item -ItemType SymbolicLink -Path C:\Users\Administrator\Desktop\ -Name "RStudio.lnk" -Value "C:\Program Files\RStudio\bin\rstudio.exe"

#rename guest account per qualys report
Rename-LocalUser -name Guest -newname NotGuest

#remove ec2 guide/feedback shortcuts
rm 'C:\Users\Administrator\Desktop\EC2 Feedback.website'
rm 'C:\Users\Administrator\Desktop\EC2 Microsoft Windows Guide.website'

#add git to path
setx path "%path%;C:\git\bin;c:\Program Files\Amazon\AWSCLIV2"