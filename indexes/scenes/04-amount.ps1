# Screenshot 4: range scan after CREATE INDEX idx_amount
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Index lab | idx_amount: type=range'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < indexes/sql/03_explain_after_amount.sql'
Invoke-SqlFile 'indexes/sql/03_explain_after_amount.sql'

Complete-Scene
