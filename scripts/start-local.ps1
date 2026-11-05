# Start local MySQL 8.4 server (Windows, no Docker).
# Usage:
#   .\start-local.ps1
#   .\start-local.ps1 -MySQLHome "C:\path\to\mysql-8.4.6-winx64"

param(
    [string]$MySQLHome = (Join-Path (Split-Path -Parent $PSScriptRoot) '..\mysql-8.4.6-winx64')
)

$ErrorActionPreference = 'Continue'

$root   = Split-Path -Parent $PSScriptRoot
$mysqld = Join-Path $MySQLHome 'bin\mysqld.exe'
$ini    = Join-Path $root 'my.local.ini'
$port   = 3307

if (-not (Test-Path $mysqld)) { throw "mysqld.exe not found: $mysqld" }

function Test-MySqlPort {
    param([int]$Port)
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $client.Connect('127.0.0.1', $Port)
        return $true
    } catch {
        return $false
    } finally {
        $client.Close()
    }
}

if (Test-MySqlPort $port) {
    Write-Host "MySQL is already running (port $port)."
    exit 0
}

Start-Process -FilePath $mysqld -ArgumentList "--defaults-file=$ini" -WindowStyle Hidden | Out-Null

for ($i = 1; $i -le 30; $i++) {
    Start-Sleep -Seconds 1
    if (Test-MySqlPort $port) {
        Write-Host "MySQL started: localhost:$port, user root, password 123."
        exit 0
    }
}

throw "MySQL did not start in time. See general.log in the my-mysql directory."
