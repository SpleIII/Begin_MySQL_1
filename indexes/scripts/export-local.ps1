# Export dumps and logs for the index lab (local MySQL server, Windows).

param(
    [string]$MySQLHome = (Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) '..\mysql-8.4.6-winx64'),
    [string]$GeneralLog = ''
)

$ErrorActionPreference = 'Stop'

$project  = Split-Path -Parent $PSScriptRoot
$repo     = Split-Path -Parent $project
$dump     = Join-Path $MySQLHome 'bin\mysqldump.exe'
$defaults = Join-Path $repo 'my.local.ini'

if (-not $GeneralLog) { $GeneralLog = Join-Path $project 'general.log' }
$env:MYSQL_PWD = '123'
Set-Location $project

cmd /c "`"$dump`" --defaults-file=`"$defaults`" -uroot index_practice > index_dump.sql"
if ($LASTEXITCODE -ne 0) { throw 'mysqldump failed' }

cmd /c "`"$dump`" --defaults-file=`"$defaults`" -uroot --set-gtid-purged=OFF --single-transaction --databases index_practice > index_dump_clean.sql"
if ($LASTEXITCODE -ne 0) { throw 'mysqldump --databases failed' }

if (Test-Path $GeneralLog) {
    Copy-Item $GeneralLog (Join-Path $project 'general.log') -Force
    python (Join-Path $project 'scripts\filter_general_log.py') general.log my_actions.log
} else {
    Write-Host "general.log not found: $GeneralLog"
}
