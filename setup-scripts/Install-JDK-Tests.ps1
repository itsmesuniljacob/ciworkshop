describe 'Check URL Path' {
  $result = "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-windows-x64.exe"
  it 'should return True' {
    $result | should be "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-windows-x64.exe"
  }
}

describe 'Get Username' {
  $output = (Get-CimInstance -Class win32_computersystem).UserName
  $uname = $output.SubString($output.LastIndexOf('\')+1)
  it 'should return 320029165' {
    $uname | should be 320029165
  }
}
