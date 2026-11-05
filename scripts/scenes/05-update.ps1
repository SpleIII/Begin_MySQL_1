# Screenshot 5: update rows and vertical output
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Begin_MySQL_1 | UPDATE + SELECT ... \G'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < scripts/scenes/sql/05-update.sql'
Invoke-SqlFile 'scripts/scenes/sql/05-update.sql'

Start-Sleep -Seconds 60

