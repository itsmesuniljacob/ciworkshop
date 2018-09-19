# Parameterizing JAVA/JDK versions
$reply = Read-Host -Prompt "This script will install JDK1.8 version to your system and add the JDK path variable in your environment variable settings. Continue?[y/n]"
if($reply -match "[yY]") {
  $JDK_VER="8u181"
  # $JDK_FULL_VER="8u181-b13"
  $JDK_PATH="C:\Program Files\Java\jdk1.8\bin"
  $source64="http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-windows-x64.exe"
  $output = (Get-CimInstance -Class win32_computersystem).UserName
  $uname = $output.SubString($output.LastIndexOf('\')+1)
  $destination64="C:\Users\$uname\JDK_$JDK_VER.exe"
  $path = @('C:\Program Files\','C:\Program Files (x86)\','C:\Users\$uname\')
  $javac = 'javac.exe'
  $client=new-object System.Net.WebClient
  $cookie="oraclelicense=accept-securebackup-cookie"
  $client.Headers.Add([System.Net.HttpRequestHeader]::Cookie,$cookie)

  function IsPowerShellAdministrator {
    $Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = New-Object System.Security.Principal.WindowsPrincipal($Identity)
    $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
  }

  function configureJava() {
    [Environment]::SetEnvironmentVariable("PATH",([Environment]::GetEnvironmentVariable("PATH","User"))+"$JDK_PATH","User")
  }
  ###############################

  'Checking if Java is already installed'

  # if((Test-Path "c:\Program Files (x86)\Java") -Or (Test-Path "c:\Program Files\Java"))
  # {
  # 	'No need to Install Java'
  #     Exit
  # }

  foreach($p in $path) {
  	$body = Get-Childitem -Path $p -Include javac.exe -Recurse -ErrorAction SilentlyContinue
  	if ($body[0].Name -eq $javac) {
  		"Found java compiler"
  		$out=&"javac.exe" -version 2>&1
  		$version = $out[0].toString().SubString(6,3)
      If ($version -eq "1.8" -Or $version -eq "1.7" -Or $version -eq "1.6")
      {
        "Compatible version of JAVA found"
        break
      }
  	}
  }

  # Check Elevation
  if (!(IsPowerShellAdministrator)) {
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
    Exit
  }

  configureJava

  if($?) {
  	"Path variable set"
  } else {
  	 "Path variable setting failed"
     Exit
  }
} else {
  "Script aborted"
}


#set-executionpolicy remotesigned
