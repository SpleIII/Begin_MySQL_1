# Screenshot 3: EXPLAIN before the index on amount
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Index lab | EXPLAIN before: type=ALL'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < indexes/sql/02_explain_before.sql'
Invoke-SqlFile 'indexes/sql/02_explain_before.sql'

Complete-Scene
