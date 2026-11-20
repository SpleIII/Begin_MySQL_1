. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'border test'
& $MySQL --defaults-file=my.local.ini -uroot -t -e "SELECT 1 AS a; SELECT 2 AS b; SELECT 3 AS c;"
Write-Host 'END'
Complete-Scene
