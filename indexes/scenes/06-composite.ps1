# Screenshot 6: composite index (status, amount)
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Index lab | composite (status, amount)'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < indexes/sql/05_composite_index.sql'
Invoke-SqlFile 'indexes/sql/05_composite_index.sql'

Complete-Scene
