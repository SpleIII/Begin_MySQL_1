# Screenshot 1: server version, character set, databases
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Begin_MySQL_1 | MySQL 8.4.6 | server + charset'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < scripts/scenes/sql/01-server.sql'
Invoke-SqlFile 'scripts/scenes/sql/01-server.sql'

Start-Sleep -Seconds 60

