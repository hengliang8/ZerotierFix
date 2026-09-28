$ErrorActionPreference = 'Stop'

$rootDir = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$coreDir = Join-Path $rootDir 'externals/core'
$patchFile = Join-Path $rootDir 'patches/zerotier-core-1.16.2.patch'

$previousErrorAction = $ErrorActionPreference
$ErrorActionPreference = 'Continue'
& git -C $coreDir apply --reverse --check $patchFile 2>$null
$ErrorActionPreference = $previousErrorAction
if ($LASTEXITCODE -eq 0) {
    Write-Host 'ZeroTier Android patches already applied'
    exit 0
}

& git -C $coreDir apply --check $patchFile
if ($LASTEXITCODE -ne 0) {
    throw 'ZeroTier Android patch does not apply cleanly'
}

& git -C $coreDir apply $patchFile
if ($LASTEXITCODE -ne 0) {
    throw 'Failed to apply ZeroTier Android patch'
}

Write-Host 'Applied ZeroTier Android patches'
