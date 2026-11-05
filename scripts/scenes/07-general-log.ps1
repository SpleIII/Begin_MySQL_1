# Screenshot 7: general_log
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Begin_MySQL_1 | general_log'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < scripts/scenes/sql/07-general-log.sql'
Invoke-SqlFile 'scripts/scenes/sql/07-general-log.sql'

Start-Sleep -Seconds 60

