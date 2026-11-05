# Screenshot 3: insert first rows and select
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Begin_MySQL_1 | INSERT + SELECT'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < scripts/scenes/sql/03-insert.sql'
Invoke-SqlFile 'scripts/scenes/sql/03-insert.sql'

Start-Sleep -Seconds 60

