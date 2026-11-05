# Screenshot 4: more rows and HEX check of utf8mb4
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Begin_MySQL_1 | INSERT + HEX (utf8mb4)'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < scripts/scenes/sql/04-crud.sql'
Invoke-SqlFile 'scripts/scenes/sql/04-crud.sql'

Start-Sleep -Seconds 60

