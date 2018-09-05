#--------------------------------------------------------------------------------------------------------------------------------#
##                  Java automated install using PowerShell script                                                               #
##                  ----------------------------------------------                           									 #
## This power shell script will do automated installation of specified JDK from Oracle site and set user environment variables   #
## in your system  																												 #
##-------------------------------------------------------------------------------------------------------------------------------#

# Parameterizing JAVA/JDK versions

$JDK_VER="8u181"
# $JDK_FULL_VER="8u181-b13"
$JDK_PATH="C:\Program Files\Java\jdk1.8\bin"
$JRE_PATH="C:\Program Files\Java\jre1.8.0_181\bin"
$source64="http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-windows-x64.exe"
$output = (Get-CimInstance -Class win32_computersystem).UserName
$uname = $output.SubString($output.LastIndexOf('\')+1)
$destination64="C:\Users\$uname\JDK_$JDK_VER.exe"
$client=new-object System.Net.WebClient
$cookie="oraclelicense=accept-securebackup-cookie"
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie,$cookie)

######### Common Functions ############
# Returns whether or not the current user has administrative privileges
function IsAdministrator {
  $Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $Principal = New-Object System.Security.Principal.WindowsPrincipal($Identity)
  $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# functions to set JAVA path variable
function configureJava() {

  # Add Java to path
  #[System.Environment]::SetEnvironmentVariable("Path", "$pythonPath;$env:Path", "User")
  [Environment]::SetEnvironmentVariable("PATH",([Environment]::GetEnvironmentVariable("PATH","User"))+"$JDK_PATH","User")
  [Environment]::SetEnvironmentVariable("PATH",([Environment]::GetEnvironmentVariable("PATH","User"))+"$JRE_PATH","User")
}
###############################
'Checking if Java is already installed'

if((Test-Path "c:\Program Files (x86)\Java") -Or (Test-Path "c:\Program Files\Java"))
{
	'No need to Install Java'
    Exit
}

# Check Elevation
if (!(IsAdministrator)) {
   "Please restart this script from an administrative PowerShell!! to install JAVA"
  return
}

"Downloading JDK x64 to $destination64"
$client.downloadFile($source64,$destination64)

if(!(Test-Path $destination64))
{
	"Downloading $destination64 failed"
    Exit
}

#C:\Users\$uname\JDK_$JDK_VER.exe /s
C:\Users\$uname\JDK_$JDK_VER.exe /s

if($?) {
	"JAVA installed successfully"
} else {
	"JAVA not installed failed"
}

configureJava

if($?) {
	"Path variable set"
} else {
	 "Path variable setting failed"
}

#set-executionpolicy remotesigned
