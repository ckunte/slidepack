<#
.SYNOPSIS
  Installs the local "slidepack" Typst package (lib.typ + typst.toml) into
  Typst's local package directory, so it can be imported anywhere via:

    #import "@local/slidepack:0.1.0": slidepack

.USAGE
  # From the directory containing lib.typ and typst.toml:
  .\install-slidepack-package.ps1

  # Or point at a different source directory:
  .\install-slidepack-package.ps1 -SourceDir "C:\path\to\package\source"
#>

param(
    [string]$SourceDir = (Get-Location).Path
)

$Manifest   = Join-Path $SourceDir "typst.toml"
$Entrypoint = Join-Path $SourceDir "lib.typ"

if (-not (Test-Path $Manifest)) {
    Write-Error "typst.toml not found in $SourceDir"
    exit 1
}
if (-not (Test-Path $Entrypoint)) {
    Write-Error "lib.typ not found in $SourceDir"
    exit 1
}

# --- Parse name/version from typst.toml -----------------------------------
$manifestContent = Get-Content $Manifest -Raw

$nameMatch    = [regex]::Match($manifestContent, '(?m)^\s*name\s*=\s*"([^"]*)"')
$versionMatch = [regex]::Match($manifestContent, '(?m)^\s*version\s*=\s*"([^"]*)"')

if (-not $nameMatch.Success -or -not $versionMatch.Success) {
    Write-Error "Could not parse 'name' or 'version' from $Manifest"
    exit 1
}

$PkgName    = $nameMatch.Groups[1].Value
$PkgVersion = $versionMatch.Groups[1].Value

# --- Determine Typst data directory (Windows) ------------------------------
# %APPDATA%\typst\packages\local\<name>\<version>
$PackageDir = Join-Path $env:APPDATA "typst\packages\local\$PkgName\$PkgVersion"

Write-Host "Detected OS:      Windows"
Write-Host "Package name:     $PkgName"
Write-Host "Package version:  $PkgVersion"
Write-Host "Installing to:    $PackageDir"

New-Item -ItemType Directory -Force -Path $PackageDir | Out-Null
Copy-Item -Path $Manifest   -Destination $PackageDir -Force
Copy-Item -Path $Entrypoint -Destination $PackageDir -Force

Write-Host ""
Write-Host "Done. In any Typst document you can now use:"
Write-Host "  #import `"@local/$PkgName`:$PkgVersion`": $PkgName"
