# Screenshot 7: covering index (Using index)
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Index lab | covering index: Using index'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < indexes/sql/06_covering_index.sql'
Invoke-SqlFile 'indexes/sql/06_covering_index.sql'

Complete-Scene
