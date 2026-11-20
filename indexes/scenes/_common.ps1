# Shared setup for index-lab screenshot scenes (ASCII only).

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class ConsoleFont {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct CONSOLE_FONT_INFO_EX {
        public uint cbSize;
        public uint nFont;
        public short dwFontSizeX;
        public short dwFontSizeY;
        public int FontFamily;
        public int FontWeight;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string FaceName;
    }
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetStdHandle(int nStdHandle);
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool SetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFO_EX lpConsoleCurrentFontEx);
}
"@

$handle = [ConsoleFont]::GetStdHandle(-11)
$font = New-Object ConsoleFont+CONSOLE_FONT_INFO_EX
$font.cbSize = [System.Runtime.InteropServices.Marshal]::SizeOf($font)
$font.dwFontSizeX = 0
$font.dwFontSizeY = 12
$font.FontFamily = 54
$font.FontWeight = 400
$font.FaceName = 'Consolas'
[ConsoleFont]::SetCurrentConsoleFontEx($handle, $false, [ref]$font) | Out-Null

$w = $Host.UI.RawUI
$w.BufferSize = New-Object Management.Automation.Host.Size(240, 1000)
$w.WindowSize = New-Object Management.Automation.Host.Size(240, 50)

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

# Tell capture-console.ps1 that output is ready; keep the window open.
function Complete-Scene {
    if ($env:SCENE_READY_FILE) {
        Set-Content -Path $env:SCENE_READY_FILE -Value 'ready' -Encoding ASCII
    }
    Start-Sleep -Seconds 120
}
