# Run the whole index lab against a local MySQL server (Windows).
# The server is started by ..\..\scripts\start-local.ps1.

param(
    [string]$MySQLHome = (Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) '..\mysql-8.4.6-winx64')
)

$ErrorActionPreference = 'Stop'

$project  = Split-Path -Parent $PSScriptRoot
$repo     = Split-Path -Parent $project
$mysql    = Join-Path $MySQLHome 'bin\mysql.exe'
$defaults = Join-Path $repo 'my.local.ini'

$env:MYSQL_PWD = '123'

if (-not (Test-Path $mysql)) { throw "mysql.exe not found: $mysql" }

Get-ChildItem (Join-Path $project 'sql') -Filter '*.sql' | Sort-Object Name | ForEach-Object {
    Write-Host "==> $($_.Name)"
    cmd /c "`"$mysql`" --defaults-file=`"$defaults`" -uroot --default-character-set=utf8mb4 -t < `"$($_.FullName)`""
    if ($LASTEXITCODE -ne 0) { throw "SQL failed: $($_.Name)" }
}
