# Остановка локального сервера MySQL 8.4
# Использование:
#   .\stop-local.ps1
#   .\stop-local.ps1 -MySQLHome "C:\path\to\mysql-8.4.6-winx64"

param(
    [string]$MySQLHome = (Join-Path (Split-Path -Parent $PSScriptRoot) '..\mysql-8.4.6-winx64')
)

$ErrorActionPreference = 'Stop'

$root  = Split-Path -Parent $PSScriptRoot
$admin = Join-Path $MySQLHome 'bin\mysqladmin.exe'
$ini   = Join-Path $root 'my.local.ini'

& $admin --defaults-file=$ini -uroot -p123 shutdown
if ($LASTEXITCODE -eq 0) {
    Write-Host 'MySQL остановлен.'
} else {
    Write-Host 'MySQL не был запущен или остановить не удалось.'
}
