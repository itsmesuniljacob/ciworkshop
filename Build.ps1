param([switch]$Jenkins=$false)
$ErrorActionPreference="Stop"
function Confirm-AdministratorContext
{
    $administrator = [Security.Principal.WindowsBuiltInRole] "Administrator"
    $identity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $identity.IsInRole($administrator)
}

function Invoke-StaticAnalysis
{
    $result = Invoke-ScriptAnalyzer -Path "." -Recurse
    $result
    if ($result.Length -gt 0)
    {
        throw "Build failed. Found $($result.Length) static analysis issue(s)"
    }
    Write-Output "Static analysis findings clean"
}
function Invoke-Build
{
    if ($Jenkins)
    {
        Write-Output "Building in Jenkins build CI server context"
    }
    else
    {
        Write-Output "Building in normal context"
    }
    Write-Output "Checking static analysis findings"
    Invoke-StaticAnalysis
    Write-Output "Running tests"
    Invoke-Test
}

function Send-TestResult([string]$resultsPath)
{
    # If needed, upload test results to build server here
}
function Invoke-Test
{
    $resultsPath = ".\TestResults.xml"
    Invoke-Pester -EnableExit -OutputFormat NUnitXml -OutputFile $resultsPath
    if ($Jenkins)
    {
        Send-TestResult $resultsPath
    }
}

function Confirm-Prerequisite
{
    (
        (Get-Module -Name PSScriptAnalyzer).Length *
        (Get-Module -Name Pester).Length *
        (Get-PackageProvider -Name Nuget).Length
    ) -ne 0
}

function Install-Prerequisite
{
    if ((Confirm-Prerequisite))
    {
        return
    }

    Write-Output "Installing build prerequisites"
    $code = ".\Install-BuildPrerequisites.ps1"
    if (Confirm-AdministratorContext)
    {
        Invoke-Command "$code"
    }
    else
    {
        Start-Process -FilePath powershell.exe -ArgumentList $code -verb RunAs
    }

    if (-not (Confirm-Prerequisite))
    {
        throw "Build Failed. Installation of build prerequisites failed."
    }
}

Write-Output "Build starting"
#Install-Prerequisite
Write-Output "Building"
Invoke-Build
Write-Output "Build complete"