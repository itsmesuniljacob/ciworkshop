describe 'Test JAVA installation' {
  $out=&"javac.exe" -version 2>&1
  $version = $out[0].toString().SubString(6,3)
  it 'should return 1.8 or 1.7 or 1.6' {
    $version | should be 1.8 or 1.7 or 1.6
  }
}
