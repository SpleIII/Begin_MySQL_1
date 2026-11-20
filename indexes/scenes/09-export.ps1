# Screenshot 9: dumps and the filtered general log
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Index lab | dumps + my_actions.log'
Set-Location (Join-Path $Root 'indexes')

Write-Host ''
Write-Host 'PS> Get-Item index_dump.sql, index_dump_clean.sql, general.log, my_actions.log | Select-Object Name, Length' -ForegroundColor Yellow
Get-Item index_dump.sql, index_dump_clean.sql, general.log, my_actions.log | Select-Object Name, Length | Format-Table -AutoSize

Write-Host ''
Write-Host "PS> Select-String -Path index_dump.sql -Pattern 'CREATE INDEX|ADD KEY'" -ForegroundColor Yellow
Select-String -Path index_dump.sql -Pattern 'CREATE INDEX|ADD KEY'

Write-Host ''
Write-Host 'PS> Get-Content my_actions.log -Tail 8' -ForegroundColor Yellow
Get-Content my_actions.log -Tail 8

Set-Location $Root
Complete-Scene
