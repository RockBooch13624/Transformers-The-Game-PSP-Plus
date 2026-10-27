# Mounts the user's ISO, verifies it is the supported version, and copies
# the game files into game_data\. No game files are ever stored in the repo.
param([string]$IsoPath)
$ErrorActionPreference = 'Stop'

$ExpectedDiscId   = 'ULUS-10274'
$ExpectedBootSha1 = '483EEE94516B0C29823805C88438AD87DD9E56EF'  # PSP_GAME\SYSDIR\BOOT.BIN, v1.02

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Dest     = Join-Path $RepoRoot 'game_data'
$BootDest = Join-Path $Dest 'PSP_GAME\SYSDIR\BOOT.BIN'

# Skip extraction if a verified copy is already in place.
if ((Test-Path $BootDest) -and ((Get-FileHash $BootDest -Algorithm SHA1).Hash -eq $ExpectedBootSha1)) {
    Write-Host 'Game data already extracted and verified. Skipping.'
    exit 0
}

if (-not $IsoPath) {
    Add-Type -AssemblyName System.Windows.Forms
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title  = 'Select your Transformers: The Game (USA) PSP ISO'
    $dlg.Filter = 'PSP ISO (*.iso)|*.iso'
    if ($dlg.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        Write-Host 'No ISO selected.'
        exit 1
    }
    $IsoPath = $dlg.FileName
}

$IsoPath = (Resolve-Path $IsoPath).Path
Write-Host "Using ISO: $IsoPath"

$mounted = $false
try {
    $image = Mount-DiskImage -ImagePath $IsoPath -PassThru
    $mounted = $true
    $letter = ($image | Get-Volume).DriveLetter
    if (-not $letter) { throw 'Windows mounted the ISO but gave it no drive letter.' }
    $root = "$($letter):\"

    $umd = Join-Path $root 'UMD_DATA.BIN'
    if (-not (Test-Path $umd)) { throw 'This does not look like a PSP game ISO.' }
    $discId = ([System.IO.File]::ReadAllText($umd)).Split('|')[0]
    if ($discId -ne $ExpectedDiscId) {
        throw "Wrong game or region: found $discId, expected $ExpectedDiscId (USA)."
    }

    $boot = Join-Path $root 'PSP_GAME\SYSDIR\BOOT.BIN'
    $hash = (Get-FileHash $boot -Algorithm SHA1).Hash
    if ($hash -ne $ExpectedBootSha1) {
        throw "BOOT.BIN does not match version 1.02 (SHA-1 $hash). The ISO may be a different version or a bad dump."
    }
    Write-Host 'ISO verified.'

    Write-Host 'Copying game files (this can take a minute)...'
    if (Test-Path $Dest) { Remove-Item $Dest -Recurse -Force }
    New-Item -ItemType Directory -Path $Dest | Out-Null
    Copy-Item (Join-Path $root 'PSP_GAME') $Dest -Recurse

    # The firmware updater on the disc is not part of the game.
    $update = Join-Path $Dest 'PSP_GAME\SYSDIR\UPDATE'
    if (Test-Path $update) { Remove-Item $update -Recurse -Force }

    # Files copied from a disc can come out read-only.
    Get-ChildItem $Dest -Recurse -File | ForEach-Object { $_.IsReadOnly = $false }
    Write-Host "Game data extracted to $Dest"
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    if ($mounted) { Dismount-DiskImage -ImagePath $IsoPath | Out-Null }
}
