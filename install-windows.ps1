$ErrorActionPreference = 'Stop'

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ResourceDir = Join-Path $env:APPDATA 'REAPER'
$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

if (Get-Process -Name 'reaper' -ErrorAction SilentlyContinue) {
    throw 'Feche o REAPER antes de instalar as configurações.'
}

if (Test-Path -LiteralPath $ResourceDir) {
    $BackupDir = "$ResourceDir.backup-$Stamp"
    Copy-Item -LiteralPath $ResourceDir -Destination $BackupDir -Recurse -Force
    Write-Host "Backup do perfil existente: $BackupDir"
}

New-Item -ItemType Directory -Path $ResourceDir -Force | Out-Null
Get-ChildItem -LiteralPath (Join-Path $RepoDir 'profile') -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $ResourceDir -Recurse -Force
}
Copy-Item -LiteralPath (Join-Path $RepoDir 'platform/windows/reaper.ini') -Destination (Join-Path $ResourceDir 'reaper.ini') -Force

$WindowsCursors = Join-Path $RepoDir 'platform/windows/Cursors'
if (Test-Path -LiteralPath $WindowsCursors) {
    Copy-Item -LiteralPath $WindowsCursors -Destination $ResourceDir -Recurse -Force
}

$PresetsSource = Join-Path $RepoDir 'user-documents/VST3 Presets'
$PresetsTarget = Join-Path $env:USERPROFILE 'Documents/VST3 Presets'
New-Item -ItemType Directory -Path $PresetsTarget -Force | Out-Null
if (Test-Path -LiteralPath $PresetsSource) {
    Get-ChildItem -LiteralPath $PresetsSource -Force | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $PresetsTarget -Recurse -Force
    }
}

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
Get-ChildItem -LiteralPath $ResourceDir -Filter '*.ini' -File -Recurse | ForEach-Object {
    $Text = [System.IO.File]::ReadAllText($_.FullName)
    $Text = $Text.Replace('@REAPER_RESOURCE_PATH@', $ResourceDir)
    $Text = $Text.Replace('@VST3_PRESETS_PATH@', $PresetsTarget)
    [System.IO.File]::WriteAllText($_.FullName, $Text, $Utf8NoBom)
}

Write-Host "Configuração REAPER instalada em: $ResourceDir"
Write-Host 'Feche e reabra o REAPER para carregar as configurações.'
