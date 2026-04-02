# Build one-file Kern IDE (PyInstaller) and copy the executable to `E:\KERN-IDE`.
#
# Optional:
#   - set $env:KERN_IDE_RELEASE_DIR to override the destination folder
#   - set $env:KERN_IDE_PYTHON to override which python to use
#
# Requires:
#   pip install pyinstaller

param()

$ErrorActionPreference = "Stop"
$PackagingDir = $PSScriptRoot
$IdeRoot = Resolve-Path (Join-Path $PackagingDir "..")
$ReleaseDir = $env:KERN_IDE_RELEASE_DIR
if ([string]::IsNullOrWhiteSpace($ReleaseDir)) {
    $ReleaseDir = "E:\KERN-IDE"
}

$Py = $env:KERN_IDE_PYTHON
if ([string]::IsNullOrWhiteSpace($Py)) {
    $Py = "python"
}

Set-Location $IdeRoot
$Spec = Join-Path $PackagingDir "kern-ide.spec"
$DistExe = Join-Path $IdeRoot "dist\kern-ide.exe"
$ReleaseExe = Join-Path $ReleaseDir "kern-ide.exe"

& $Py -m PyInstaller --noconfirm $Spec
if (-not (Test-Path $DistExe)) {
    throw "Expected $DistExe after PyInstaller build."
}

New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null
Copy-Item -LiteralPath $DistExe -Destination $ReleaseExe -Force
Write-Host "Copied $ReleaseExe"

