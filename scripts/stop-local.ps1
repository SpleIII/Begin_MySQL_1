# Stop local MySQL 8.4 server.
# Usage:
#   .\stop-local.ps1
#   .\stop-local.ps1 -MySQLHome "C:\path\to\mysql-8.4.6-winx64"

param(
    [string]$MySQLHome = (Join-Path (Split-Path -Parent $PSScriptRoot) '..\mysql-8.4.6-winx64')
)

$ErrorActionPreference = 'Continue'

$root  = Split-Path -Parent $PSScriptRoot
$admin = Join-Path $MySQLHome 'bin\mysqladmin.exe'
$ini   = Join-Path $root 'my.local.ini'

$env:MYSQL_PWD = '123'

& $admin --defaults-file=$ini -uroot shutdown 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host 'MySQL stopped.'
} else {
    Write-Host 'MySQL was not running or could not be stopped.'
}
