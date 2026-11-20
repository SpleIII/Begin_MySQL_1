# Screenshot 1: server and general log settings
. "$PSScriptRoot\_common.ps1"
$Host.UI.RawUI.WindowTitle = 'Index lab | MySQL server + general log'

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t -e "SELECT VERSION() AS version, @@port AS port, @@character_set_server AS charset;"'
& $MySQL --defaults-file=my.local.ini -uroot -t -e "SELECT VERSION() AS version, @@port AS port, @@character_set_server AS charset;"

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t -e "SHOW VARIABLES LIKE ''general_log''; SHOW VARIABLES LIKE ''general_log_file'';"'
& $MySQL --defaults-file=my.local.ini -uroot -t -e "SHOW VARIABLES LIKE 'general_log'; SHOW VARIABLES LIKE 'general_log_file';"

Show-Cmd 'mysql --defaults-file=my.local.ini -uroot -p123 -t -e "SHOW DATABASES;"'
& $MySQL --defaults-file=my.local.ini -uroot -t -e "SHOW DATABASES;"

Complete-Scene
