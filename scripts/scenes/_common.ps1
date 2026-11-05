# Shared setup for screenshot scenes (ASCII only: Windows PowerShell 5.1 reads
# UTF-8 without BOM as ANSI, so all non-ASCII text lives in .sql files).

$w = $Host.UI.RawUI
$w.BufferSize = New-Object Management.Automation.Host.Size(120, 1000)
$w.WindowSize = New-Object Management.Automation.Host.Size(120, 40)

chcp 65001 > $null
[Console]::OutputEncoding = [Text.Encoding]::UTF8

$script:Root  = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$script:MySQL = (Resolve-Path (Join-Path $Root '..\mysql-8.4.6-winx64\bin\mysql.exe')).Path
$script:Dump  = (Resolve-Path (Join-Path $Root '..\mysql-8.4.6-winx64\bin\mysqldump.exe')).Path

$env:MYSQL_PWD = '123'
Set-Location $Root

function Show-Cmd([string]$Text) {
    Write-Host ''
    Write-Host "PS> $Text" -ForegroundColor Yellow
}

function Invoke-SqlFile([string]$RelativePath) {
    $path = Join-Path $Root $RelativePath
    cmd /c "`"$MySQL`" --defaults-file=my.local.ini -uroot --default-character-set=utf8mb4 -t < `"$path`""
}

