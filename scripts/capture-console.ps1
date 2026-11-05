# Capture a screenshot of a real console window running a scene script.
# Usage:
#   .\capture-console.ps1 -SceneFile .\scenes\01-server-charset.ps1 -Output ..\screenshots\01-server-charset.png

param(
    [Parameter(Mandatory = $true)][string]$SceneFile,
    [Parameter(Mandatory = $true)][string]$Output,
    [int]$Width = 0,
    [int]$Height = 0
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinCap {
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern bool BringWindowToTop(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    [DllImport("dwmapi.dll")] public static extern int DwmGetWindowAttribute(IntPtr hwnd, int dwAttribute, out RECT pvAttribute, int cbAttribute);
    public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }
}
"@
[WinCap]::SetProcessDPIAware() | Out-Null

$scene = (Resolve-Path $SceneFile).Path
$outPath = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $Output))
$outDir = Split-Path -Parent $outPath
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$proc = Start-Process powershell.exe -ArgumentList @(
    '-NoLogo', '-NoExit', '-ExecutionPolicy', 'Bypass', '-File', $scene
) -PassThru

$handle = [IntPtr]::Zero
for ($i = 0; $i -lt 60; $i++) {
    Start-Sleep -Milliseconds 250
    $proc.Refresh()
    if ($proc.MainWindowHandle -ne 0) { $handle = $proc.MainWindowHandle; break }
}
if ($handle -eq [IntPtr]::Zero) {
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    throw 'Console window was not created.'
}

[WinCap]::ShowWindow($handle, 9) | Out-Null          # SW_RESTORE

$sizeRect = New-Object WinCap+RECT
[WinCap]::GetWindowRect($handle, [ref]$sizeRect) | Out-Null
$winW = $sizeRect.Right - $sizeRect.Left
$winH = $sizeRect.Bottom - $sizeRect.Top

[WinCap]::MoveWindow($handle, 60, 60, $winW, $winH, $true) | Out-Null
[WinCap]::BringWindowToTop($handle) | Out-Null
[WinCap]::SetForegroundWindow($handle) | Out-Null
Start-Sleep -Milliseconds 2000

# DWMWA_EXTENDED_FRAME_BOUNDS = 9: visible frame without the DWM shadow margins
$rect = New-Object WinCap+RECT
$ok = [WinCap]::DwmGetWindowAttribute($handle, 9, [ref]$rect, [System.Runtime.InteropServices.Marshal]::SizeOf($rect))
if ($ok -ne 0) { [WinCap]::GetWindowRect($handle, [ref]$rect) | Out-Null }
$w = $rect.Right - $rect.Left
$h = $rect.Bottom - $rect.Top
if ($Width -gt 0) { $w = $Width }
if ($Height -gt 0) { $h = $Height }

$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($rect.Left, $rect.Top, 0, 0, (New-Object System.Drawing.Size $w, $h))
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()

Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
Write-Host "Saved: $outPath ($w x $h)"
