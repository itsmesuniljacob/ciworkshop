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
    $success=$false
    try {
        $success=((
            (Get-Command -Module PSScriptAnalyzer).Length *
            (Get-Command -Module Pester).Length *
            (Get-PackageProvider | Where-Object {$_.Name -eq "NuGet"}).Length
        ) -ne 0)
    }
    catch {
        Write-Output "One or more prerequisites not available: $_Exception.Message"
        break
    }
    $success
}

Write-Output "Build starting"
if (-not (Confirm-Prerequisite))
{
    throw "Build failed. Prerequisites missing. Please run Install-BuildPrerequisites.ps1 (running as administrator if needed)"
}
Write-Output "Building"
Invoke-Build
Write-Output "Build complete"