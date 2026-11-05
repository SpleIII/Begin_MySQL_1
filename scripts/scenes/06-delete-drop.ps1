# Screenshot 6: delete row, drop table and database
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Begin_MySQL_1 | DELETE / DROP TABLE / DROP DATABASE'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < scripts/scenes/sql/06-delete-drop.sql'
Invoke-SqlFile 'scripts/scenes/sql/06-delete-drop.sql'

Start-Sleep -Seconds 60

