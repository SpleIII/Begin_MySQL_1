# Screenshot 5: function in WHERE vs range rewrite
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Index lab | YEAR(order_date) vs range'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < indexes/sql/04_function_index.sql'
Invoke-SqlFile 'indexes/sql/04_function_index.sql'

Complete-Scene
