# Запуск локального сервера MySQL 8.4 (Windows, без Docker)
# Использование:
#   .\start-local.ps1
#   .\start-local.ps1 -MySQLHome "C:\path\to\mysql-8.4.6-winx64"

param(
    [string]$MySQLHome = (Join-Path (Split-Path -Parent $PSScriptRoot) '..\mysql-8.4.6-winx64')
)

$ErrorActionPreference = 'Stop'

$root   = Split-Path -Parent $PSScriptRoot
$mysqld = Join-Path $MySQLHome 'bin\mysqld.exe'
$admin  = Join-Path $MySQLHome 'bin\mysqladmin.exe'
$ini    = Join-Path $root 'my.local.ini'

if (-not (Test-Path $mysqld)) { throw "mysqld.exe не найден: $mysqld" }

& $admin --defaults-file=$ini -uroot -p123 ping 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host 'MySQL уже запущен (порт 3307).'
    exit 0
}

Start-Process -FilePath $mysqld -ArgumentList "--defaults-file=$ini" -WindowStyle Hidden | Out-Null

for ($i = 1; $i -le 30; $i++) {
    Start-Sleep -Seconds 1
    & $admin --defaults-file=$ini -uroot -p123 ping 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host 'MySQL запущен: localhost:3307, пользователь root, пароль 123.'
        exit 0
    }
}

throw 'Не удалось дождаться запуска MySQL. Смотрите general.log в каталоге my-mysql.'
