# Screenshot 8: EXPLAIN ANALYZE with real timings
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Index lab | EXPLAIN ANALYZE'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < indexes/sql/07_explain_analyze.sql'
Invoke-SqlFile 'indexes/sql/07_explain_analyze.sql'

Complete-Scene
