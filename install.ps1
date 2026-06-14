# Tarkhan CLI installer (Windows / PowerShell).
#   iwr https://raw.githubusercontent.com/tarkhan-io/tarkhan-cli/main/install.ps1 | iex
$ErrorActionPreference = 'Stop'
$repo = $env:TARKHAN_CLI_REPO; if (-not $repo) { $repo = 'tarkhan-io/tarkhan-cli' }
$tarkhanHome = $env:TARKHAN_HOME; if (-not $tarkhanHome) { $tarkhanHome = Join-Path $HOME '.tarkhan' }

Write-Host "> tarkhan installer - querying latest release"
$meta = Invoke-RestMethod "https://raw.githubusercontent.com/$repo/main/version.json"
$ver  = $meta.version
$appDir = Join-Path $tarkhanHome 'app'
$dest = Join-Path $appDir $ver
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$tmp = Join-Path $env:TEMP "tarkhan-cli-$ver.tar.gz"
Write-Host "> downloading $($meta.asset)"
Invoke-WebRequest -Uri $meta.asset -OutFile $tmp
Write-Host "> extracting to $dest"
tar -xzf $tmp -C $dest
Remove-Item $tmp -Force

# Repoint current (plain text pointer, read by the launcher each run)
Set-Content -Path (Join-Path $appDir 'current') -Value $ver -NoNewline

# Stable launcher shims in the npm global bin dir (already on PATH).
# They resolve app/current at run time, so 'tarkhan update' takes effect
# without re-running this installer.
$binDir = Join-Path $env:APPDATA 'npm'
New-Item -ItemType Directory -Force -Path $binDir | Out-Null
$onPath = ($env:PATH -split ';') -contains $binDir
if (-not $onPath) {
  Write-Warning "tarkhan: '$binDir' is not on your PATH. Add it to PATH so the 'tarkhan' command resolves."
}

$cmdLauncher = @"
@ECHO off
SETLOCAL
FOR /F "usebackq delims=" %%V IN ("$appDir\current") DO SET "TKVER=%%V"
node "$appDir\%TKVER%\bin\tarkhan" %*
"@
Set-Content -Path (Join-Path $binDir 'tarkhan.cmd') -Value $cmdLauncher -Encoding Ascii

$ps1Launcher = @"
#!/usr/bin/env pwsh
`$tkver = (Get-Content (Join-Path '$appDir' 'current')).Trim()
node (Join-Path '$appDir' (Join-Path `$tkver 'bin/tarkhan')) `$args
exit `$LASTEXITCODE
"@
Set-Content -Path (Join-Path $binDir 'tarkhan.ps1') -Value $ps1Launcher -Encoding Utf8

Write-Host "> installed tarkhan $ver - run 'tarkhan --version'"
