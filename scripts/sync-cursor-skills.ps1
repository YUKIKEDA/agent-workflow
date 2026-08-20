$ErrorActionPreference = 'Stop'

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$SrcRoot = Join-Path $RepoRoot 'skills'
$DstRoot = Join-Path $RepoRoot '.cursor\skills'

if (-not (Test-Path -LiteralPath $SrcRoot)) {
    throw "skills/ not found: $SrcRoot"
}

New-Item -ItemType Directory -Force -Path $DstRoot | Out-Null

Get-ChildItem -LiteralPath $SrcRoot -Directory | ForEach-Object {
    $dst = Join-Path $DstRoot $_.Name
    if (Test-Path -LiteralPath $dst) {
        Remove-Item -LiteralPath $dst -Recurse -Force
    }
    Copy-Item -LiteralPath $_.FullName -Destination $dst -Recurse
    Write-Output "synced $($_.Name)"
}
