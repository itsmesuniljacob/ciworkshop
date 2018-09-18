Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'

Write-Host -Object "`nInstalling modules:" -ForegroundColor 'Yellow'

foreach ( $moduleName in 'Pester', 'Posh-Git', 'Coveralls' ) {
    Write-Host -Object ( '   {0}' -f $module )
    Install-Module -Name $moduleName -Scope 'CurrentUser' -Force -Confirm:$false |
        Out-Null
}
Remove-Variable -Name moduleName

Write-Host -Object ''
