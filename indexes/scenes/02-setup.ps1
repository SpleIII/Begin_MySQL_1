# Screenshot 2: database and source tables
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Index lab | 01_setup.sql: customers + orders'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t < indexes/sql/01_setup.sql'
Invoke-SqlFile 'indexes/sql/01_setup.sql'

Complete-Scene
